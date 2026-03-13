import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/owner/equipment/widgets/delete_equipment_section.dart';
import 'package:prokat/features/owner/equipment/widgets/editable_field_tile.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_details_sheet.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_image_header.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_section_card.dart';
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
    final state = ref.watch(ownerEquipmentProvider);
    final equipment = state.equipment
        .where((e) => e.id == equipmentId)
        .firstOrNull;

    if (equipment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Equipment not found")),
      );
    }

    return Scaffold(
      // appBar: AppBar(title: Text(equipment.name)),
      body: ListView(
        children: [
          EquipmentImageHeader(
            imageUrl: equipment.imageUrl,
            onEdit: () => showImagePickerSheet(context),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                EquipmentSectionCard(
                  title: "Equipment Details",
                  actionIcon: Icons.edit_rounded,
                  onAction: () =>
                      equipmentDetailsSheet(context, ref, equipment),
                  children: [
                    EditableFieldTile(label: "Name", value: equipment.name),
                    EditableFieldTile(label: "Model", value: equipment.model),
                    EditableFieldTile(
                      label: "Capacity",
                      value: "${equipment.capacity} units",
                    ),
                    EditableFieldTile(
                      label: "Comment",
                      value: equipment.ownerComment.toString(),
                    ),
                    EditableFieldTile(
                      label: "Renting Condition",
                      value: equipment.rentCondition.toString(),
                    ),
                  ],
                ),

                PricingSection(
                  prices: equipment.prices,
                  onAdd: () => openPricingEditSheet(
                    context,
                    ref,
                    equipment.id,
                  ), // Open empty for Add
                  onEdit: (entry) => openPricingEditSheet(
                    context,
                    ref,
                    equipment.id,
                    priceEntry: entry,
                  ), // Pass entry for Edit
                ),

                LocationSection(
                  location: equipment.locations.isNotEmpty
                      ? '${equipment.locations[0].street}, ${equipment.locations[0].city}'
                      : null,
                  onAction: () => openLocationPickerSheet(context, ref, equipment.id),
                ),

                VisibilityStatusSection(
                  isVisible: equipment.isVisible,
                  status: equipment.status,
                  onSave: (visible, status) {
                    ref
                        .read(ownerEquipmentProvider.notifier)
                        .updateVisibilityStatus(equipment.id, visible, status);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Availability updated successfully"),
                      ),
                    );
                  },
                ),

                DeleteEquipmentSection(
                  onDelete: () => _confirmDelete(context, ref, equipmentId),
                ),
              ],
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
                  await ref.read(ownerEquipmentProvider.notifier).deleteEquipment(equipmentId);

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
