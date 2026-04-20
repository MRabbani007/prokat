import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/core/widgets/app_link_button.dart';
import 'package:prokat/features/favorites/state/favorites_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/favorites/widgets/favorite_item_tile.dart';

class FavoritesSection extends ConsumerWidget {
  const FavoritesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Assuming favoriteProvider returns a list of Equipment objects
    final favorites = ref.watch(favoriteProvider).favorites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER SECTION ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Favorites",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (favorites?.isNotEmpty == true)
              AppLinkButton(
                label: "View All",
                onTap: () => context.push(AppRoutes.favorites),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // --- CONTENT SECTION ---
        if (favorites?.isEmpty == true)
          _buildEmptyFavorites(theme)
        else
          SizedBox(
            height: 220, // Adjust height based on your equipment tile design
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favorites?.length,
              itemBuilder: (context, index) {
                final item = favorites?[index];
                if (item == null) {
                  return null;
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FavoriteItemTile(
                      equipment: item,
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyFavorites(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite_border,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Items you favorite will appear here",
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
