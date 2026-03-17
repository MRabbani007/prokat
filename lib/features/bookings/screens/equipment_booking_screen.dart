import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/equipment_image_header.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_provider.dart';
import 'package:go_router/go_router.dart';

class EquipmentBookingScreen extends ConsumerStatefulWidget {
  final String equipmentId;

  const EquipmentBookingScreen({super.key, required this.equipmentId});

  @override
  ConsumerState<EquipmentBookingScreen> createState() =>
      _EquipmentBookingScreenState();
}

class _EquipmentBookingScreenState
    extends ConsumerState<EquipmentBookingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ownerEquipmentProvider.notifier).loadEquipment();
      ref.read(locationProvider.notifier).loadAddresses();
    });
  }

  int selectedPriceIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    /// 🔥 AUTO SYNC address → booking
    ref.listen(locationProvider, (previous, next) {
      final address = next.selectedAddress;

      if (address != null && address.id != null) {
        ref.read(bookingProvider.notifier).selectLocation(address);
      }
    });

    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final state = ref.watch(ownerEquipmentProvider);
    final locationState = ref.watch(locationProvider);

    final selectedAddress = locationState.selectedAddress;

    if (state.equipment.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final equipmentList = state.equipment.where(
      (e) => e.id == widget.equipmentId,
    );

    final equipment = equipmentList.isNotEmpty ? equipmentList.first : null;

    if (equipment == null) {
      return const Scaffold(body: Center(child: Text("Equipment not found")));
    }

    final priceEntries = equipment.prices;
    final location = equipment.locations.isNotEmpty
        ? equipment.locations.first
        : null;

    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : testImage;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Equipment Image
            EquipmentImageHeader(imageUrl: displayUrl),

            const SizedBox(height: 16),

            /// Name
            Text(
              "${equipment.name} ${equipment.model}",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            /// Capacity
            Text(
              "Capacity: ${equipment.capacity} ${equipment.capacityUnit}",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),

            const Divider(height: 32),

            /// Details
            _buildSectionTitle("Details & Conditions"),

            Text(
              "Owner Comment: ${equipment.ownerComment ?? 'No comment provided.'}",
            ),

            const SizedBox(height: 8),

            Text("Rent Condition: ${equipment.rentCondition}"),

            const SizedBox(height: 12),

            if (location != null)
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text("${location.street}, ${location.city}"),
                ],
              ),

            const Divider(height: 32),

            /// Pricing
            _buildSectionTitle("Select Pricing Plan"),

            Wrap(
              spacing: 8,
              children: List.generate(priceEntries.length, (index) {
                final entry = priceEntries[index];

                return ChoiceChip(
                  label: Text("${entry.price} ₸ / ${entry.priceRate}"),
                  selected:
                      bookingState.selectedPriceEntry?.id ==
                      priceEntries[index].id,
                  onSelected: (_) {
                    ref
                        .read(bookingProvider.notifier)
                        .selectPriceEntry(priceEntries[index]);
                    setState(() {
                      selectedPriceIndex = index;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 24),

            /// Address
            _buildSectionTitle("Delivery Address"),

            GestureDetector(
              onTap: () => _openAddressSheet(context, ref),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.blue),

                    const SizedBox(width: 12),

                    Expanded(
                      child: selectedAddress != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Delivery to",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${selectedAddress.street}, ${selectedAddress.city}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              "Add Delivery Address",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                    ),

                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Schedule
            _buildSectionTitle("Schedule Rental"),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      bookingState.selectedDate == null
                          ? "Select Date"
                          : DateFormat(
                              'MMM dd, yyyy',
                            ).format(bookingState.selectedDate!),
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (date != null) {
                        bookingNotifier.setDate(date);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      bookingState.selectedTime == null
                          ? "Select Time"
                          : TimeOfDay.fromDateTime(
                              bookingState.selectedTime!,
                            ).format(context),
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        final now = DateTime.now();

                        bookingNotifier.setTime(
                          DateTime(
                            now.year,
                            now.month,
                            now.day,
                            time.hour,
                            time.minute,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Notes
            _buildSectionTitle("Additional Notes"),

            TextField(
              maxLines: 3,
              onChanged: (value) {
                bookingNotifier.setComment(value);
              },
              decoration: InputDecoration(
                hintText: "Anything the owner should know?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed:
                    bookingState.selectedLocationId == null ||
                        bookingState.selectedDate == null ||
                        bookingState.selectedTime == null
                    ? null
                    : () async {
                        final res = await bookingNotifier.createBooking();

                        if (context.mounted && res == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Booking created")),
                          );

                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong!"),
                            ),
                          );
                        }
                      },
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _openAddressSheet(BuildContext context, WidgetRef ref) {
    final addresses = ref.read(locationProvider).addresses.take(3).toList();

    // ref.read(locationProvider.notifier).selectAddress(address);

    // ref.read(bookingProvider.notifier).selectLocation(address.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// Last 3 addresses
              ...addresses.map((address) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text("${address.street}, ${address.city}"),
                  onTap: () {
                    ref.read(locationProvider.notifier).selectAddress(address);

                    Navigator.pop(context);
                  },
                );
              }),

              const SizedBox(height: 12),

              /// Choose on map
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("Choose on Map"),
                  onPressed: () {
                    Navigator.pop(context); // close bottom sheet

                    context.push(
                      '/addresses/pintomap',
                      extra: {'equipmentId': widget.equipmentId},
                    );

                    // final result =
                    // if (result != null) {
                    //   ref.read(locationProvider.notifier).selectAddress(result);
                    // }
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
