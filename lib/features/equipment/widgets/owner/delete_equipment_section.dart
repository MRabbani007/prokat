import 'package:flutter/material.dart';

class DeleteEquipmentSection extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteEquipmentSection({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final danger = colorScheme.error;
    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.7);

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: danger, size: 30),
              const SizedBox(width: 8),
              Text(
                "DANGER ZONE",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: danger.withValues(alpha: 0.85),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            "Deleting this equipment will permanently remove it from your inventory, including all pricing and history.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ghostGray,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          /// DELETE BUTTON
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_outlined, size: 30),
              label: const Text(
                "Delete Equipment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: danger,
                side: BorderSide(color: danger.withValues(alpha: 0.4)),
                backgroundColor: danger.withValues(alpha: 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
