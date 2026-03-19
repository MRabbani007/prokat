import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/core/widgets/industrial_date_time_button.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/equipment_image_header.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/locations/widgets/address_picker_card.dart';
import 'package:prokat/features/locations/widgets/select_address_sheet.dart';
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
    // final location = equipment.locations.isNotEmpty
    //     ? equipment.locations.first
    //     : null;

    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : testImage;

    // Inside your _BookingScreenState build method
    final bgColor = const Color(0xFF121417);
    final cardColor = const Color(0xFF1E2125);
    final accentColor = const Color(0xFF4E73DF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: "Book Equipment"),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 1. ASSET HEADER CARD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EquipmentImageHeader(imageUrl: displayUrl),
                          const SizedBox(height: 16),
                          Text(
                            "${equipment.name} ${equipment.model}"
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "SPEC: ${equipment.capacity} ${equipment.capacityUnit}",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 2. PRICING PLAN SELECTOR
                    _buildSectionHeader("SELECT PRICING PLAN"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(priceEntries.length, (index) {
                        final entry = priceEntries[index];
                        final isSelected =
                            bookingState.selectedPriceEntry?.id == entry.id;

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(bookingProvider.notifier)
                                .selectPriceEntry(entry);
                            setState(() => selectedPriceIndex = index);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? accentColor : cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? accentColor
                                    : Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              "${entry.price} ₸ / ${entry.priceRate}",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    /// 3. LOGISTICS (Address & Schedule)
                    _buildSectionHeader("LOGISTICS"),
                    AddressPickerCard(
                      selectedAddress: selectedAddress,
                      onTap: () => _openAddressSheet(context, ref),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: IndustrialDateTimeBtn(
                            icon: Icons.calendar_today_rounded,
                            label: bookingState.selectedDate == null
                                ? "Date"
                                : DateFormat(
                                    'MMM dd',
                                  ).format(bookingState.selectedDate!),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) bookingNotifier.setDate(date);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IndustrialDateTimeBtn(
                            icon: Icons.access_time_rounded,
                            label: bookingState.selectedTime == null
                                ? "Time"
                                : TimeOfDay.fromDateTime(
                                    bookingState.selectedTime!,
                                  ).format(context),
                            onTap: () async {
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

                    /// 4. ADDITIONAL NOTES
                    _buildSectionHeader("OPERATIONAL NOTES"),
                    TextField(
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: (v) => bookingNotifier.setComment(v),
                      decoration: InputDecoration(
                        hintText: "Site access details, conditions...",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        filled: true,
                        fillColor: cardColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4E73DF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            /// 5. STICKY ACTION FOOTER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed:
                      (bookingState.selectedLocationId == null ||
                          bookingState.selectedDate == null)
                      ? null
                      : () async {
                          final res = await bookingNotifier.createBooking();
                          if (context.mounted && res == true) {
                            context.pop();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white.withValues(
                      alpha: 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets to keep build clean
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

void _openAddressSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent, // For rounded corners
    isScrollControlled: true,
    builder: (context) => const SelectAddressSheet(equipmentId: "your_id"),
  );
}
