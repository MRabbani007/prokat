import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/owner/equipment/widgets/delete_equipment_section.dart';
import 'package:prokat/features/owner/equipment/widgets/edit_equipment_details_form.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_image_header.dart';
import 'package:prokat/features/owner/equipment/widgets/location_section.dart';
import 'package:prokat/features/owner/equipment/widgets/open_location_picker_sheet.dart';
import 'package:prokat/features/owner/equipment/widgets/open_pricing_edit_sheet.dart';
import 'package:prokat/features/owner/equipment/widgets/pricing_section.dart';
import 'package:prokat/features/owner/equipment/widgets/show_image_picker_sheet.dart';
import 'package:prokat/features/owner/equipment/widgets/visibility_status_section.dart';
import '../providers/owner_equipment_provider.dart';

class OwnerEquipmentDetailScreen extends ConsumerWidget {
  final String equipmentId;

  const OwnerEquipmentDetailScreen({super.key, required this.equipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bgColor = Color(0xFF121417);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentColor = Color(0xFF4E73DF);

    final state = ref.watch(ownerEquipmentProvider);
    final equipment = state.equipment
        .where((e) => e.id == equipmentId)
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
        // Using CustomScrollView for a smoother feel with the ImageHeader
        slivers: [
          // Assuming ImageHeader is updated to industrial style
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
                EditEquipmentDetailsForm(equipment: equipment, ref: ref),

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
                        .read(ownerEquipmentProvider.notifier)
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
                      .read(ownerEquipmentProvider.notifier)
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

// Reusable Industrial Panel Wrapper
class _IndustrialSectionWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onAction;

  const _IndustrialSectionWrapper({
    required this.title,
    required this.child,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2125), // Industrial Charcoal
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0x4DFFFFFF),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                if (onAction != null)
                  IconButton(
                    onPressed: onAction,
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: Color(0xFF4E73DF),
                      size: 22,
                    ),
                  ),
              ],
            ),
          ),
          child,
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// Styled Data Tile
class _IndustrialTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _IndustrialTile({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0x4DFFFFFF),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
