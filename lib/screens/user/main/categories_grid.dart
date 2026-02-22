import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/data/mock_categories.dart';
import 'package:prokat/screens/user/main/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // 👈 VERY IMPORTANT
      physics: const NeverScrollableScrollPhysics(), // 👈 disable inner scroll
      padding: const EdgeInsets.all(0),
      itemCount: mockCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final category = mockCategories[index];

        return CategoryCard(
          category: category,
          onTap: () {
            context.push('/search', extra: category);
          },
        );
      },
    );
  }
}
