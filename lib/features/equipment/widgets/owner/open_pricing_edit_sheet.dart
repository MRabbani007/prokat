import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/edit_sheet.dart';
import 'package:prokat/core/widgets/industrial_input_container.dart';
import 'package:prokat/features/equipment/models/price_entry_model.dart';
import 'package:prokat/core/constants/price_rate_options.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';

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
    final notifier = ref.read(equipmentProvider.notifier);

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
      // Close drawer
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
  const ghostGray = Color(0x4DFFFFFF);
  const accentBlue = Color(0xFF4E73DF);

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
      title: isEditing ? "Edit Rate" : "New Rate",
      buttonText: isEditing ? "Save" : "Add",
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
        builder: (context, setLocalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PRICE INPUT (Recessed Terminal Style)
              IndustrialInputContainer(
                label: "UNIT PRICE (₸)",
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'monospace',
                  ),
                  decoration: const InputDecoration(
                    hintText: "0.00",
                    hintStyle: TextStyle(color: ghostGray),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. RATE TYPE SELECTOR
              IndustrialInputContainer(
                label: "PRICE RATE",
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: priceRateOptions.any((e) => e.value == selectedRate)
                        ? selectedRate
                        : priceRateOptions.first.value,
                    dropdownColor: const Color(0xFF1E2125),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.expand_more_rounded,
                      color: accentBlue,
                    ),
                    items: priceRateOptions
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option.value,
                            child: Text(
                              option.label.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setLocalState(() => selectedRate = value.toUpperCase());
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. SERVICE TIME
              IndustrialInputContainer(
                label: "SERVICE DURATION (MINUTES)",
                child: TextField(
                  controller: serviceTimeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "60",
                    hintStyle: TextStyle(color: ghostGray),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

// Reusable Industrial Input Wrapper for the Sheet
