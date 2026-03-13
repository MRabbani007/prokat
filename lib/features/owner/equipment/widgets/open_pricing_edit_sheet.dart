import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/edit_sheet.dart';
import 'package:prokat/core/widgets/modern_dropdown.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/features/owner/equipment/constants/price_rate_options.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_provider.dart';
import 'package:prokat/features/owner/equipment/widgets/modern_text_field.dart';

Future<void> submitPriceEntry(
  BuildContext context,
  WidgetRef ref,
  String equipmentId,
  PriceEntry? priceEntry,
  TextEditingController priceController,
  TextEditingController serviceTimeController,
  String selectedRate,
) async {
  final price = int.tryParse(priceController.text.trim());
  final serviceTime = int.tryParse(serviceTimeController.text.trim()) ?? 0;

  if (price == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Please enter a valid price")));
    return;
  }

  try {
    final notifier = ref.read(ownerEquipmentProvider.notifier);

    if (priceEntry == null) {
      await notifier.createPriceEntry(
        equipmentId,
        price,
        selectedRate,
        serviceTime,
      );
    } else {
      await notifier.updatePriceEntry(equipmentId, {
        "id": priceEntry.id,
        "price": price,
        "priceRate": selectedRate,
        "serviceTime": serviceTime,
      });
    }

    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            priceEntry == null ? "Price entry created" : "Price entry updated",
          ),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Failed to save price entry")));
  }
}

void openPricingEditSheet(
  BuildContext context,
  WidgetRef ref,
  String equipmentId, {
  PriceEntry? priceEntry,
}) {
  final isEditing = priceEntry != null;

  final priceController = TextEditingController(
    text: isEditing ? priceEntry.price.toString() : "",
  );

  final serviceTimeController = TextEditingController(
    text: isEditing ? priceEntry.serviceTime.toString() : "",
  );

  String selectedRate = isEditing
      ? priceEntry.priceRate
      : priceRateOptions.first.value;

  showEditSheet(
    context: context,
    sheet: EditSheet(
      title: isEditing ? "Edit Pricing" : "Add Pricing",
      buttonText: isEditing ? "Update Price" : "Add Price",
      onSubmit: () => submitPriceEntry(
        context,
        ref,
        equipmentId,
        priceEntry,
        priceController,
        serviceTimeController,
        selectedRate,
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              ModernTextField(
                controller: priceController,
                label: "Price (₸)",
                icon: Icons.payments_rounded,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              ModernDropdown<String>(
                value: priceRateOptions.any((e) => e.value == selectedRate)
                    ? selectedRate
                    : priceRateOptions.first.value,
                label: "Rate Type",
                icon: Icons.speed_rounded,
                items: priceRateOptions
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option.value,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRate = value.toUpperCase();
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              ModernTextField(
                controller: serviceTimeController,
                label: "Service Time (minutes)",
                icon: Icons.timer_outlined,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        },
      ),
    ),
  );
}
