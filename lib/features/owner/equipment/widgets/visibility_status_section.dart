import 'package:flutter/material.dart';
import 'package:prokat/features/owner/equipment/widgets/equipment_section_card.dart';

class VisibilityStatusSection extends StatefulWidget {
  final bool isVisible;
  final String status; // "available", "rented", "maintenance", etc.
  final Function(bool newVisibility, String newStatus) onSave;

  const VisibilityStatusSection({
    super.key,
    required this.isVisible,
    required this.status,
    required this.onSave,
  });

  @override
  State<VisibilityStatusSection> createState() =>
      _VisibilityStatusSectionState();
}

class _VisibilityStatusSectionState extends State<VisibilityStatusSection> {
  late bool _tempVisible;
  late String _tempStatus;

  @override
  void initState() {
    super.initState();
    _tempVisible = widget.isVisible;
    _tempStatus = widget.status;
  }

  // Check if current selection differs from original data
  bool get _isDirty =>
      (_tempVisible != widget.isVisible) ||( _tempStatus != widget.status);

  @override
  Widget build(BuildContext context) {
    print("tempstatus");
    print(_tempStatus);
    return EquipmentSectionCard(
      title: "Marketplace Presence",
      // Show the save button only if there's a change
      actionIcon: _isDirty
          ? Icons.check_circle_rounded
          : Icons.lock_outline_rounded,
      isActionEnabled: _isDirty,
      onAction: _isDirty
          ? () => widget.onSave(_tempVisible, _tempStatus)
          : null,
      children: [
        // 1. Visibility Toggle
        _InlineActionRow(
          label: "Public Visibility",
          trailing: Switch.adaptive(
            value: _tempVisible,
            onChanged: (v) => setState(() => _tempVisible = v),
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          "Current Availability",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // 2. Modern Segmented Status Picker
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["AVAILABLE", "BOOKED", "MAINTENANCE"].map((s) {
              final isSelected = _tempStatus == s;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _tempStatus = s);
                  },
                  showCheckmark: false,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Simple Helper for Rows
class _InlineActionRow extends StatelessWidget {
  final String label;
  final Widget trailing;
  const _InlineActionRow({required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing,
      ],
    );
  }
}
