import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    
    // Theme Constants
    const bgColor = Color(0xFF121417);
    const accentColor = Color(0xFF4E73DF);

    Future<void> onCategorySelected(BuildContext context, Category category) async {
      ref.read(selectedCategoryProvider.notifier).state = category;
      if (context.mounted) {
        context.go('/search/map', extra: {'category': category.id});
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: "Select Service"),
            
            Padding(padding: EdgeInsets.all(5)),

            Expanded( // Prevents layout crashes
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(
                      child: Text("No categories available", 
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.2))),
                    );
                  }
              
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns for a "pro" catalog look
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85, // Adjust based on icon/text size
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _ServiceCard(
                        category: category,
                        onTap: () => onCategorySelected(context, category),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: accentColor, strokeWidth: 2),
                ),
                error: (error, stack) => Center(
                  child: Text("Error: $error", style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _ServiceCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const accentColor = Color(0xFF4E73DF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container with industrial tint
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                // Logic to map category names to icons or use dynamic icons
                _getCategoryIcon(category.name), 
                color: accentColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "View Equipment", // Subtitle for depth
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple icon mapper
  IconData _getCategoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('septic')) return Icons.local_shipping_rounded;
    if (n.contains('truck')) return Icons.fire_truck_rounded;
    if (n.contains('excavator')) return Icons.precision_manufacturing_rounded;
    return Icons.construction_rounded;
  }
}
