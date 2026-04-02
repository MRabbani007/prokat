import 'package:flutter/material.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/equipment/widgets/owner/category_selection_sheet.dart';

Widget SelectCategoryTile({
  required BuildContext context,
  required IconData icon,
  required String label,
  required String? selectedCategoryName,
  required Color cardColor,

  /// List of categories
  required List<Category> categories,

  /// Current selected ID
  required String? selectedCategoryId,

  /// Callback when changed
  required Function(Category cat) onChanged,

  /// UI mode
  bool useBottomSheet = true,
}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet<Category>(
        context: context,
        isScrollControlled: true,
        backgroundColor:
            Colors.transparent, // Important for our custom border radius
        builder: (context) => const CategorySelectionSheet(service: "equipment"),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4E73DF), size: 22),
          ),

          const SizedBox(width: 16),

          /// Content
          Expanded(
            child: useBottomSheet
                ? _buildDisplayMode(label, selectedCategoryName)
                : _buildDropdownMode(
                    label,
                    categories,
                    selectedCategoryId,
                    onChanged,
                  ),
          ),

          /// Arrow for bottom sheet
          if (useBottomSheet)
            const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    ),
  );
}

Widget _buildDisplayMode(String label, String? value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value ?? "Select category",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget _buildDropdownMode(
  String label,
  List<Category> categories,
  String? selectedId,
  Function(Category cat) onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 6),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedId,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2D),
          items: categories.map((cat) {
            return DropdownMenuItem(value: cat.id, child: Text(cat.name));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final found = categories.firstWhere((cat) => cat.id == value);
              onChanged(found);
            }
          },
        ),
      ),
    ],
  );
}
