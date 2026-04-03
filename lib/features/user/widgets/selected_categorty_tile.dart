import 'package:flutter/material.dart';
import 'package:prokat/features/categories/models/category.dart';

class SelectedServiceTile extends StatelessWidget {
  final Category service;
  final VoidCallback clearSelected;

  const SelectedServiceTile({super.key, required this.service, required this.clearSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.2), width: 2),
      ),
      child: Row(
        children: [
          // Icon (you can map based on service type)
          Icon(_getServiceIcon(service), color: accent, size: 20),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              service.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Optional: clear button
          GestureDetector(
            onTap: ()=>clearSelected(),
            child: Icon(Icons.close, size: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(Category service) {
    switch (service.name.toLowerCase()) {
      case 'septic':
        return Icons.local_shipping;
      case 'crane':
        return Icons.construction;
      case 'forklift':
        return Icons.forklift;
      default:
        return Icons.build;
    }
  }
}
