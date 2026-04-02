import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prokat/core/widgets/industrial_text_field.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/widgets/owner/category_selection_sheet.dart';
import 'package:prokat/features/equipment/widgets/owner/category_selector_tile.dart';
import 'package:prokat/features/locations/state/location_provider.dart';
import 'package:prokat/features/locations/widgets/address_picker_card.dart';
import 'package:prokat/features/locations/widgets/select_address_sheet.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final capacityController = TextEditingController();
  final rateController = TextEditingController();
  final commentController = TextEditingController();

  Category? _selectedCategory;

  // Theme Constants
  final bgColor = const Color(0xFF121417);
  final cardColor = const Color(0xFF1E2125);
  final accentColor = const Color(0xFF4E73DF);

  void _openAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SelectAddressSheet(),
    );
  }

  void onCategoryTap() async {
    final Category? picked = await showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, 
      builder: (context) => const CategorySelectionSheet(service: "request"),
    );

    if (picked != null) {
      setState(() {
        _selectedCategory = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(locationProvider.notifier).getRenterLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);
    final requestState = ref.watch(requestProvider);
    final requestNotifier = ref.read(requestProvider.notifier);
    final categoriesProv = ref.watch(categoriesProvider);

    // Auto sync address
    ref.listen(locationProvider, (previous, next) {
      final address = next.selectedAddress;

      if (address != null && address.id != null) {
        ref.read(requestProvider.notifier).selectLocation(address);
      }
    });

    ref.listen(userProfileProvider, (previous, next) {
      final profileCategoryId = next.userProfile?.selectedCategoryId;

      final foundCategory = categoriesProv.categories
          .where((item) => item.id == profileCategoryId)
          .firstOrNull;

      if (profileCategoryId != null && foundCategory != null) {
        ref.read(requestProvider.notifier).selectCategory(foundCategory);
      }
    });

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: "New Request"),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CategorySelectorTile(
                    selectedCategory: _selectedCategory,
                    onTap: onCategoryTap,
                  ),

                  _buildSectionLabel("DELIVERY LOCATION"),
                  AddressPickerCard(
                    selectedAddress: locationState.selectedAddress,
                    onTap: () => _openAddressSheet(context),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionLabel("SPECIFICATIONS"),

                  IndustrialTextField(
                    controller: capacityController,
                    label: "Required Capacity",
                    hint: "e.g. 10 Kub",
                    icon: Icons.high_quality_rounded,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      ref
                          .read(requestProvider.notifier)
                          .setCapacity(value.toString());
                    },
                  ),
                  IndustrialTextField(
                    controller: rateController,
                    label: "Offered Rate",
                    hint: "Price you're willing to pay",
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final rate = int.tryParse(value);

                      if (rate != null) {
                        ref.read(requestProvider.notifier).setOfferedRate(rate);
                      }
                    },
                  ),
                  IndustrialTextField(
                    controller: commentController,
                    label: "Comments",
                    hint: "Additional details...",
                    icon: Icons.chat_bubble_outline_rounded,
                    maxLines: 3,
                    onChanged: (value) {
                      ref.read(requestProvider.notifier).setComment(value);
                    },
                  ),

                  const SizedBox(height: 24),
                  _buildSectionLabel("SCHEDULE"),

                  Row(
                    children: [
                      Expanded(
                        child: _DateTimeButton(
                          icon: Icons.calendar_today_rounded,
                          label: requestState.selectedDate == null
                              ? "Select Date"
                              : DateFormat(
                                  'MMM dd, yyyy',
                                ).format(requestState.selectedDate!),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (date != null) requestNotifier.setDate(date);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateTimeButton(
                          icon: Icons.access_time_rounded,
                          label: requestState.selectedTime == null
                              ? "Select Time"
                              : TimeOfDay.fromDateTime(
                                  requestState.selectedTime!,
                                ).format(context),
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              final now = DateTime.now();
                              requestNotifier.setTime(
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
                  const SizedBox(height: 40),
                ],
              ),
            ),

            /// Fixed Footer Button
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
                  onPressed: () async {
                    final res = await requestNotifier.createRequest();

                    if (context.mounted && res == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request created")),
                      );

                      context.pop();
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Something went wrong!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.white.withValues(
                      alpha: 0.05,
                    ),
                    disabledForegroundColor: Colors.white.withValues(
                      alpha: 0.2,
                    ),
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "SUBMIT REQUEST",
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

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        label,
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

class _DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimeButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2125),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4E73DF), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
