import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/owner/delete_equipment_section.dart';
import 'package:prokat/features/equipment/widgets/owner/edit_equipment_details_form.dart';
import 'package:prokat/features/equipment/widgets/owner/equipment_image_header.dart';
import 'package:prokat/features/equipment/widgets/owner/location_section.dart';
import 'package:prokat/features/equipment/widgets/owner/open_location_picker_sheet.dart';
import 'package:prokat/features/equipment/widgets/owner/open_pricing_edit_sheet.dart';
import 'package:prokat/features/equipment/widgets/owner/pricing_section.dart';
import 'package:prokat/features/equipment/widgets/owner/show_image_picker_sheet.dart';
import 'package:prokat/features/equipment/widgets/owner/visibility_status_section.dart';

class OwnerEquipmentDetailScreen extends ConsumerWidget {
  final String equipmentId;

  const OwnerEquipmentDetailScreen({super.key, required this.equipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bgColor = Color(0xFF121417);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentColor = Color(0xFF4E73DF);

    final state = ref.watch(equipmentProvider);

    final equipment = state.editEquipment;

    final categories = ref.read(categoriesProvider).categories;

    final foundCategory = categories
        .where((item) => item.id == equipment?.categoryId)
        .firstOrNull;

    // Industrial Fallback for Error State
    if (equipment == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFD97706),
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "SYSTEM ERROR",
                style: TextStyle(
                  color: ghostGray,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                "EQUIPMENT DATA NOT LOCATED",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  "BACK TO FLEET",
                  style: TextStyle(color: accentColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: EquipmentImageHeader(
              imageUrl: equipment.imageUrl,
              onEdit: () => showImagePickerSheet(context),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                EditEquipmentDetailsForm(
                  equipment: equipment,
                  ref: ref,
                  category: foundCategory,
                ),

                const SizedBox(height: 20),

                // 2. PRICING PANEL
                PricingSection(
                  // Ensure PricingSection internal widgets use the 0.08 alpha white border
                  prices: equipment.prices,
                  onAdd: () => openPricingEditSheet(context, ref, equipment.id),
                  onEdit: (entry) => openPricingEditSheet(
                    context,
                    ref,
                    equipment.id,
                    priceEntry: entry,
                  ),
                ),

                const SizedBox(height: 20),

                // 3. LOGISTICS PANEL
                LocationSection(
                  location: equipment.locations.isNotEmpty
                      ? '${equipment.locations[0].street}, ${equipment.locations[0].city}'
                      : "NO LOCATION SET",
                  onAction: () =>
                      openLocationPickerSheet(context, ref, equipment.id),
                ),

                const SizedBox(height: 20),

                // 4. SYSTEM STATUS PANEL
                VisibilityStatusSection(
                  isVisible: equipment.isVisible,
                  status: equipment.status,
                  onSave: (visible, status) {
                    ref
                        .read(equipmentProvider.notifier)
                        .updateVisibilityStatus(equipment.id, visible, status);
                  },
                ),

                const SizedBox(height: 40),

                // 5. DESTRUCTIVE ACTION
                DeleteEquipmentSection(
                  onDelete: () => _confirmDelete(context, ref, equipmentId),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String equipmentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          MediaQuery.of(ctx).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),

            // Warning Icon with soft glow (2026 style)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_sweep_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Delete Equipment?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "This will remove the item from the marketplace and delete all its rental history.",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 32),

            // GO-ROUTER INTEGRATION HERE
            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  // 1. Trigger the logic
                  await ref
                      .read(equipmentProvider.notifier)
                      .deleteEquipment(equipmentId);

                  // 2. Close the BottomSheet (using GoRouter)
                  if (ctx.canPop()) ctx.pop();

                  // 3. Navigate back to the list/previous screen
                  if (context.mounted) {
                    // Option A: Just go back
                    context.pop();

                    // Option B: Hard redirect to equipment list if preferred
                    // context.go('/owner/inventory');
                  }
                },
                child: const Text(
                  "Yes, Delete Permanently",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ctx.pop(), // Close sheet only
              child: const Text("Keep it for now"),
            ),
          ],
        ),
      ),
    );
  }
}
