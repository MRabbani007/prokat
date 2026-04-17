import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: 0.5,
        ), // Themed background
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            // Updates URL to include ?query=xxx
            context.push(
              Uri(
                path: '/main',
                queryParameters: {'query': value},
              ).toString(),
            );
          }
        },
        decoration: InputDecoration(
          hintText: 'Search equipment...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          icon: Icon(Icons.search, size: 20, color: theme.colorScheme.primary),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
