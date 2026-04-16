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
    final accent = Theme.of(context).colorScheme.primary;

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
        Text(
          "Service",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesState.categories.length,
            itemBuilder: (context, index) {
              final cat = categoriesState.categories[index];
              final isSelected = categoriesState.selectedCategory?.id == cat.id;

              return GestureDetector(
                onTap: () => onCategorySelected(context, cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 160,
                  margin: const EdgeInsets.fromLTRB(0, 4, 12, 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? accent.withValues(alpha: 0.3)
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// IMAGE (RECTANGLE)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colorScheme.surface,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            (cat.imageUrl != null && cat.imageUrl!.isNotEmpty)
                            ? Image.network(
                                cat.imageUrl!,
                                fit: BoxFit.fitWidth,
                                errorBuilder: (_, _, _) =>
                                    _fallbackImage(theme),
                              )
                            : _fallbackImage(theme),
                      ),

                      const SizedBox(height: 4),

                      /// TEXT BELOW IMAGE
                      Text(
                        cat.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? accent
                              : theme.textTheme.bodyMedium?.color?.withValues(
                                  alpha: 0.9,
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
