import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/widgets/edit_sheet.dart';
import 'package:prokat/core/widgets/industrial_input_container.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/offers/providers/offers_provider.dart';
import 'package:prokat/features/requests/models/request_model.dart';

void openResponseSheet(BuildContext context, RequestModel request) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          final offersState = ref.watch(offersProvider);
          final offersNotifier = ref.read(offersProvider.notifier);
          final equipmentState = ref.watch(equipmentProvider);
          final selectedCategory = ref
              .watch(categoriesProvider)
              .selectedCategory;
          final equipmentOptions = equipmentState.ownerEquipment
              .where((e) => e.category?.id == selectedCategory?.id)
              .toList();

          return EditSheet(
            title: "Send Offer",
            buttonText: "Send",
            onSubmit: () async {
              final res = await offersNotifier.createOffer();

              if (res == true) {
                Navigator.pop(context);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// CATEGORY
                // InfoBar(
                //   label: "TARGET CATEGORY",
                //   value: offersState.selectedRequest?.category?.name ?? "",
                // ),

                // const SizedBox(height: 16),

                /// ✅ EQUIPMENT DROPDOWN (REAL DATA)
                IndustrialInputContainer(
                  label: "Select Equipment",
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: offersState.selectedEquipment,
                      dropdownColor: const Color(0xFF1E2125),
                      items: equipmentOptions.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          offersNotifier.selectEquipment(value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price
                Row(
                  children: [
                    Expanded(
                      child: IndustrialInputContainer(
                        label: "PRICE",
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            offersNotifier.setPrice(int.tryParse(value) ?? 0);
                          },
                          decoration: const InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IndustrialInputContainer(
                        label: "RATE TYPE",
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: offersState.priceRate,
                            hint: const Text(
                              "Per day",
                              style: TextStyle(color: Colors.white38),
                            ),
                            dropdownColor: const Color(0xFF1E2125),
                            items: ["Per hour", "Per day", "Fixed"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              offersNotifier.setPriceRate(value ?? "");
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// ✅ DATE / DURATION (from selected request)
                Row(
                  children: [
                    /// ✅ DATE
                    Expanded(
                      child: IndustrialInputContainer(
                        label: "START DATE",
                        child: GestureDetector(
                          behavior: HitTestBehavior
                              .opaque, // 🔥 makes whole area clickable
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  offersState.selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );

                            if (date != null) {
                              offersNotifier.setDate(date);
                            }
                          },
                          child: Text(
                            offersState.selectedDate != null
                                ? offersState.selectedDate!
                                      .toString()
                                      .split(" ")
                                      .first
                                : "Select date",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ✅ TIME
                    Expanded(
                      child: IndustrialInputContainer(
                        label: "START TIME",
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (time != null) {
                              final now = DateTime.now();

                              offersNotifier.setTime(
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
                          child: Text(
                            offersState.selectedTime != null
                                ? TimeOfDay.fromDateTime(
                                    offersState.selectedTime!,
                                  ).format(context)
                                : "Select time",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const SizedBox(height: 16),

                /// ✅ COMMENT INPUT (CONNECTED)
                IndustrialInputContainer(
                  label: "Comment",
                  child: TextField(
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      offersNotifier.setComment(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "Comments or terms...",
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
