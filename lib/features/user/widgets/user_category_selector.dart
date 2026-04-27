import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';
import 'package:go_router/go_router.dart';

class UserCategorySelector extends ConsumerWidget {
  const UserCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);
    final userProfileState = ref.read(userProfileProvider.notifier);
    final theme = Theme.of(context);

    Future<void> onCategorySelected(
      BuildContext context,
      Category category,
    ) async {
      ref.read(categoriesProvider.notifier).selectCategory(category);

      await userProfileState.selectCategory(category.id);

      if (context.mounted) {
        final uri = Uri(
          path: AppRoutes.searchList,
          queryParameters: {'category': category.id},
        ).toString();
        context.push(uri);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            "Explore Services", // More engaging title
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),
        SizedBox(
          height: 140, // Slightly shorter for better vertical rhythm
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesState.categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categoriesState.categories[index];
              final isSelected = categoriesState.selectedCategory?.id == cat.id;

              return GestureDetector(
                onTap: () => onCategorySelected(context, cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width:
                      130, // Square-ish look is trendier than long rectangles
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: theme.cardColor,
                    border: Border.all(
                      color: isSelected
                          ? theme.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? theme.primaryColor.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // 1. Background Image (Lower opacity or contained)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                (cat.imageUrl != null &&
                                    cat.imageUrl!.isNotEmpty)
                                ? Image.network(
                                    cat.imageUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) =>
                                        _fallbackImage(theme),
                                  )
                                : _fallbackImage(theme),
                          ),
                        ),
                      ),

                      // 2. Subtle Gradient for Text Readability
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(24),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                theme.cardColor.withValues(alpha: 0.8),
                                theme.cardColor,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. Label Text
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected ? theme.primaryColor : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _fallbackImage(ThemeData theme) {
  return Container(
    color: theme.colorScheme.surface,
    alignment: Alignment.center,
    child: Icon(
      Icons.image_not_supported_outlined,
      size: 28,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    ),
  );
}
