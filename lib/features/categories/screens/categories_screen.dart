import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/categories/models/category.dart';

import '../providers/category_provider.dart';
import '../widgets/category_tile.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    /// Logic to persist category and navigate
    Future<void> onCategorySelected(
      BuildContext context,
      Category category,
    ) async {
      // 1. Set local data
      ref.read(selectedCategoryProvider.notifier).state = category;

      // 2. Navigate to search/map with query parameter
      if (context.mounted) {
        context.go('/search/map', extra: {'category': category.id});
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Select Category")),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text("No categories available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryTile(
                category: category,
                onTap: () => onCategorySelected(context, category),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }
}
