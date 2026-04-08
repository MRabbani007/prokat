import 'package:flutter/material.dart';
import 'package:prokat/features/categories/models/category.dart';

class CategorySelectorTile extends StatelessWidget {
  final Category? selectedCategory;
  final VoidCallback onTap;

  const CategorySelectorTile({
    super.key,
    this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedCategory != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ?  theme.colorScheme.primary.withValues(alpha: 0.6)
                    : theme.colorScheme.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected
                    ? _getCategoryIcon(selectedCategory!.name)
                    : Icons.category_outlined,
                color: isSelected ?  theme.colorScheme.primary : theme.colorScheme.secondary.withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service",
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSelected
                        ? selectedCategory!.name.toUpperCase()
                        : "Select Service",
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            // Trailing arrow
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('septic')) return Icons.local_shipping_rounded;
    if (n.contains('truck')) return Icons.fire_truck_rounded;
    if (n.contains('excavator')) return Icons.precision_manufacturing_rounded;
    return Icons.construction_rounded;
  }
}
