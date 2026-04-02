import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/equipment/widgets/owner/category_selection_sheet.dart';
import 'package:prokat/features/equipment/widgets/owner/category_selector_tile.dart';

class EditEquipmentDetailsForm extends StatefulWidget {
  final Equipment equipment;
  final Category? category;
  final WidgetRef ref;

  const EditEquipmentDetailsForm({
    super.key,
    required this.equipment,
    this.category,
    required this.ref,
  });

  @override
  State<EditEquipmentDetailsForm> createState() =>
      _EditEquipmentDetailsFormState();
}

class _EditEquipmentDetailsFormState extends State<EditEquipmentDetailsForm> {
  late TextEditingController _nameController;
  late TextEditingController _modelController;
  late TextEditingController _capacityController;
  late TextEditingController _commentController;
  late TextEditingController _rentConditionController;

  Category? _selectedCategory;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment.name);
    _modelController = TextEditingController(text: widget.equipment.model);
    _capacityController = TextEditingController(
      text: widget.equipment.capacity.toString(),
    );
    _commentController = TextEditingController(
      text: widget.equipment.ownerComment ?? "",
    );
    _rentConditionController = TextEditingController(
      text: widget.equipment.rentCondition,
    );
    _selectedCategory = widget.category;
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final capacity = int.tryParse(_capacityController.text.trim());

    if (name.isEmpty || capacity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SYSTEM ERROR: INVALID INPUT DATA")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final res = await widget.ref
          .read(equipmentProvider.notifier)
          .updateEquipment(widget.equipment.id, {
            "id": widget.equipment.id,
            "name": name,
            "model": _modelController.text.trim(),
            "capacity": capacity,
            "ownerComment": _commentController.text.trim(),
            "rentCondition": _rentConditionController.text.trim(),
            "categoryId": _selectedCategory?.id,
          });

      if (mounted && res == true) {
        setState(() {
          _isDirty = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Equipment Updated")));
      } else if (mounted) {
        setState(() {
          _isDirty = true;
          _isSaving = false;
        });
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Update Failed!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentBlue = Color(0xFF4E73DF);

    void onCategoryTap() async {
      // Open the sheet and wait for the result
      final Category? picked = await showModalBottomSheet<Category>(
        context: context,
        isScrollControlled: true,
        backgroundColor:
            Colors.transparent, // Important for our custom border radius
        builder: (context) =>
            const CategorySelectionSheet(service: "equipment"),
      );

      // If the user actually picked something, update local form state
      if (picked != null) {
        setState(() {
          _selectedCategory = picked;
          _isDirty = true; // Marks form as edited so Save button enables
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "INFORMATION",
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                _isDirty
                    ? TextButton.icon(
                        onPressed: _isSaving ? null : _handleSave,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 16),
                        label: const Text("Save"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: accentBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: ghostGray,
                          size: 18,
                        ),
                      ),
              ],
            ),
          ),

          CategorySelectorTile(
            selectedCategory: _selectedCategory,
            onTap: onCategoryTap,
          ),

          // Form Fields
          _IndustrialInputField(
            label: "NAME",
            controller: _nameController,
            onChanged: _onChanged,
          ),
          _IndustrialInputField(
            label: "MODEL",
            controller: _modelController,
            onChanged: _onChanged,
          ),
          _IndustrialInputField(
            label: "CAPACITY",
            controller: _capacityController,
            onChanged: _onChanged,
            isNumeric: true,
            suffixText: _selectedCategory?.capacityUnit,
          ),
          _IndustrialInputField(
            label: "RENT CONDITION",
            controller: _rentConditionController,
            onChanged: _onChanged,
          ),
          _IndustrialInputField(
            label: "COMMENTS",
            controller: _commentController,
            onChanged: _onChanged,
            isLast: true,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _IndustrialInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool isNumeric;
  final bool isLast;
  final String? suffixText; // New property for the unit (e.g., 'm³' or 'Tons')

  const _IndustrialInputField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.isNumeric = false,
    this.isLast = false,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF4E73DF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ), // Increased padding for touch target
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color.fromARGB(255, 190, 190, 190),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: (_) => onChanged(),
                  keyboardType: isNumeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  cursorColor: accentColor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    // Hint text style for empty states
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              if (suffixText != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    suffixText!,
                    style: const TextStyle(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
