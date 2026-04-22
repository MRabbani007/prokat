import 'package:flutter/material.dart';
import 'package:prokat/core/widgets/inline_tile.dart';

class VisibilityStatusSection extends StatefulWidget {
  final bool isVisible;
  final String status;
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

  bool get _isDirty =>
      (_tempVisible != widget.isVisible) || (_tempStatus != widget.status);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final accent = colorScheme.primary;
    final warning = theme.colorScheme.error;

    return InlineTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("STATUS", style: theme.textTheme.titleLarge),

              if (_isDirty)
                FilledButton.icon(
                  onPressed: () => widget.onSave(_tempVisible, _tempStatus),
                  icon: const Icon(Icons.sync_rounded, size: 16),
                  label: const Text("Save"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              else
                Icon(Icons.lock_outline_rounded, color: ghostGray, size: 18),
            ],
          ),

          SizedBox(height: 12),

          /// VISIBILITY SWITCH
          Row(
            children: [
              Expanded(
                child: Text(
                  "Available for rent",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _tempVisible,
                activeThumbColor: accent,
                activeTrackColor: accent.withValues(alpha: 0.3),
                onChanged: (v) => setState(() => _tempVisible = v),
              ),
            ],
          ),
          SizedBox(height: 12),

          /// STATUS LABEL
          Text(
            "Operating status",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: ghostGray,
            ),
          ),
          SizedBox(height: 8),

          /// STATUS SELECTOR
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["AVAILABLE", "BOOKED", "MAINTENANCE"].map((s) {
                final isSelected = _tempStatus == s;
                final isWarning = s == "MAINTENANCE";

                final Color activeColor = isWarning ? warning : accent;

                return GestureDetector(
                  onTap: () => setState(() => _tempStatus = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.12)
                          : colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? activeColor
                            : colorScheme.onSurface.withValues(alpha: 0.05),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      s,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: isSelected ? activeColor : ghostGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
