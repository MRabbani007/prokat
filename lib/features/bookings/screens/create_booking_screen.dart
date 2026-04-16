import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/core/widgets/industrial_date_time_button.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/bookings/state/booking_provider.dart';
import 'package:prokat/features/bookings/widgets/equipment_image_header.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/locations/widgets/address_picker_card.dart';
import 'package:prokat/features/locations/widgets/select_address_sheet.dart';
import 'package:go_router/go_router.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  final String equipmentId;

  const CreateBookingScreen({super.key, required this.equipmentId});

  @override
  ConsumerState<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(equipmentProvider.notifier).getRenterEquipment();
      ref.read(locationProvider.notifier).getRenterLocations();
    });
  }

  int selectedPriceIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// AUTO SYNC address → booking
    ref.listen(locationProvider, (previous, next) {
      final address = next.selectedAddress;

      if (address != null && address.id != null) {
        ref.read(bookingProvider.notifier).selectLocation(address);
      }
    });

    final bookingState = ref.watch(bookingProvider);
    final bookingNotifier = ref.read(bookingProvider.notifier);

    final state = ref.watch(equipmentProvider);
    final locationState = ref.watch(locationProvider);

    final selectedAddress = locationState.selectedAddress;

    if (state.renterEquipment.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final equipmentList = state.renterEquipment.where(
      (e) => e.id == widget.equipmentId,
    );

    final equipment = equipmentList.isNotEmpty ? equipmentList.first : null;

    if (equipment == null) {
      return const Scaffold(body: Center(child: Text("Equipment not found")));
    }

    final priceEntries = equipment.prices;

    String testImage =
        "https://insqvwqlfhbfcqqnvzxu.supabase.co/storage/v1/object/public/Media/kamaz1.jpg";
    final displayUrl = equipment.imageUrl?.isNotEmpty == true
        ? equipment.imageUrl!
        : testImage;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EquipmentImageHeader(imageUrl: displayUrl),
                        const SizedBox(height: 16),
                        Text(
                          "${equipment.name} ${equipment.model}".toUpperCase(),
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          "SPEC: ${equipment.capacity} ${equipment.capacityUnit}",
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Pricing
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Pricing Plan",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),

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
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                            ),
                            child: Text(
                              "${entry.price} ₸ / ${entry.priceRate}",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    /// Address & Schedule
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Address & Schedule",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),

                    AddressPickerCard(
                      selectedAddress: selectedAddress,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Colors.transparent, // For rounded corners
                        isScrollControlled: true,
                        builder: (context) =>
                            const SelectAddressSheet(equipmentId: "your_id"),
                      ),
                    ),

                    const SizedBox(height: 16),

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

                        const SizedBox(width: 16),

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
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        "Note to Operator",
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),

                    TextField(
                      maxLines: 3,
                      style: theme.textTheme.bodyMedium,
                      onChanged: (v) => bookingNotifier.setComment(v),
                      decoration: InputDecoration(
                        hintText: "Site access details, conditions...",
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.cardColor,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// 5. STICKY ACTION FOOTER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
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
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor: theme.colorScheme.onSurface
                        .withValues(alpha: 0.12),
                    disabledForegroundColor: theme.colorScheme.onSurface
                        .withValues(alpha: 0.38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "CONFIRM",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
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
}
