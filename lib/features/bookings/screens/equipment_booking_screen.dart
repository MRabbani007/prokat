import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/features/bookings/widgets/equipment_image_header.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_provider.dart';

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
    });
  }

  int selectedPriceIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? userAddress = "123 Caspian Ave, Atyrau";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerEquipmentProvider);

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
                  selected: selectedPriceIndex == index,
                  onSelected: (_) {
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

            userAddress != null
                ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.home_outlined),
                    title: Text(userAddress!),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text("Change"),
                    ),
                  )
                : OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text("Add Delivery Address"),
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
                      selectedDate == null
                          ? "Select Date"
                          : DateFormat('MMM dd, yyyy').format(selectedDate!),
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        setState(() => selectedTime = time);
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
                onPressed: () {
                  // TODO booking logic
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
}
