import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/equipment/providers/equipment_provider.dart';
import 'package:prokat/features/requests/providers/request_provider.dart';

class CategorySelectionSheet extends ConsumerWidget {
  final service;

  const CategorySelectionSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Read your categories list
    final categories = ref.watch(categoriesProvider).categories;
    const backgroundColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "SELECT CATEGORY",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // 2. List the categories
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.construction_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    if (service == "request") {
                      // 3. Update the Request Notifier
                      ref
                          .read(requestProvider.notifier)
                          .selectCategory(category);
                    } else if (service == "equipment") {
                      // 3. Update the Equipment Notifier
                      ref
                          .read(equipmentProvider.notifier)
                          .selectCategory(category);
                    }

                    // 4. Close the sheet and return the category to the form
                    Navigator.pop(context, category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
