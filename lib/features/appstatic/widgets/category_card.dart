import 'package:flutter/material.dart';
import 'package:prokat/features/categories/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              // padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                // border: Border.all(
                //   color: isSelected
                //       ? theme.colorScheme.primary
                //       : theme.colorScheme.outline.withValues(alpha: 0.2),
                // ),
                // borderRadius: BorderRadius.circular(16),
              ),
              child: Image.network(
                height: 72, // 👈 image limit only
                category.imageUrl ?? "",
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Text(
            category.name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? theme.primaryColor
                  : theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
