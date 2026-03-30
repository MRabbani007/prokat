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
    // const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);
    final isSelected = selectedCategory != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // decoration: BoxDecoration(
        //   color: cardColor,
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(
        //     color: isSelected
        //         ? accentColor.withValues(alpha: 0.3)
        //         : Colors.white.withValues(alpha: 0.05),
        //   ),
        // ),
        child: Row(
          children: [
            // Icon Container (Small version of your original)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected
                    ? _getCategoryIcon(selectedCategory!.name)
                    : Icons.category_outlined,
                color: isSelected ? accentColor : Colors.white24,
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
                    isSelected ? "CATEGORY" : "EQUIPMENT TYPE",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSelected
                        ? selectedCategory!.name.toUpperCase()
                        : "Select Category",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
