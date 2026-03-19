import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/equipment/models/equipment_model.dart';
import 'package:prokat/features/owner/equipment/providers/owner_equipment_provider.dart';

class EditEquipmentDetailsForm extends StatefulWidget {
  final Equipment equipment;
  final WidgetRef ref;

  const EditEquipmentDetailsForm({
    super.key,
    required this.equipment,
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
      await widget.ref
          .read(ownerEquipmentProvider.notifier)
          .updateEquipment(widget.equipment.id, {
            "id": widget.equipment.id,
            "name": name,
            "model": _modelController.text.trim(),
            "capacity": capacity,
            "ownerComment": _commentController.text.trim(),
            "rentCondition": _rentConditionController.text.trim(),
          });

      if (mounted) {
        setState(() {
          _isDirty = false;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("EQUIPMENT DATABASE UPDATED")),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("UPDATE FAILED: CONNECTION ERROR")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentBlue = Color(0xFF4E73DF);

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
                  "TECHNICAL SPECIFICATIONS",
                  style: TextStyle(
                    color: ghostGray,
                    fontSize: 10,
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

  const _IndustrialInputField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.isNumeric = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            label,
            style: const TextStyle(
              color: Color(0x4DFFFFFF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextFormField(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            cursorColor: const Color(0xFF4E73DF),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
