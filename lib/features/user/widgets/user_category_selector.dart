import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/categories/models/category.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/user/state/user_profile_provider.dart';

class UserCategorySelector extends ConsumerWidget {
  const UserCategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesProvider);
    final userProfileState = ref.read(userProfileProvider.notifier);
    final accent = Theme.of(context).colorScheme.primary;

    final theme = Theme.of(context);

    final Map<String, IconData> categoryIcons = {
      'septic trucks': Icons.plumbing_rounded,
      'manipulators': Icons.precision_manufacturing_rounded,
      'cranes': Icons.architecture_rounded,
      'excavators': Icons.construction_rounded,
      'forklifts': Icons.forklift,
      'tow trucks': Icons.car_repair_rounded,
    };

    Future<void> onCategorySelected(
      BuildContext context,
      Category category,
    ) async {
      ref.read(categoriesProvider.notifier).selectCategory(category);

      await userProfileState.selectCategory(category.id);

      // if (res == true && context.mounted) {
      //   context.go('/search/map', extra: {'category': category.id});
      // }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1, // collapse upwards
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child:
          categoriesState.showSelect == true ||
              categoriesState.selectedCategory == null || true
          ? SizedBox(
              key: const ValueKey('service_list'),
              height: 150, // your existing height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Text(
                      "Service",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 110, // Increased height to fit larger icons
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categoriesState.categories.length,
                      itemBuilder: (context, index) {
                        final cat = categoriesState.categories[index];
                        final isSelected =
                            categoriesState.selectedCategory?.id == cat.id;
                        final icon =
                            categoryIcons[cat.name.toLowerCase()] ??
                            Icons.local_shipping_rounded;

                        return GestureDetector(
                          onTap: () => onCategorySelected(context, cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 90,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accent.withOpacity(0.12)
                                  : theme
                                        .cardColor, // or scaffoldBackgroundColor
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? accent.withOpacity(0.4)
                                    : accent.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon container
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? accent.withOpacity(0.2)
                                        : accent.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(icon, size: 28, color: accent),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? accent
                                        : theme.textTheme.bodyMedium?.color,
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
              ),
            )
          : const SizedBox(key: ValueKey('empty')),
    );
  }
}
