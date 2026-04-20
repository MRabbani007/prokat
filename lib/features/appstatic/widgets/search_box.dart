import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // Use the late controller defined at the class level
  late final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize or sync controller from URL
    final params = GoRouterState.of(context).uri.queryParameters;
    final urlQuery = params['query'] ?? '';

    if (_searchController.text != urlQuery) {
      _searchController.text = urlQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters(Map<String, String?> newParams) {
    final uri = GoRouterState.of(context).uri;
    final currentParams = Map<String, String>.from(uri.queryParameters);

    newParams.forEach((key, value) {
      if (value == null || value.trim().isEmpty) {
        currentParams.remove(key);
      } else {
        currentParams[key] = value;
      }
    });

    currentParams['page'] = '1';

    // Ensure AppRoutes.main is the correct path string
    context.go(Uri(path: uri.path, queryParameters: currentParams).toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        border: Border.all(
          color: (theme.colorScheme.outline).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        // Use the persistent controller here
        controller: _searchController,
        onSubmitted: (value) => _updateFilters({"query": value}),
        decoration: InputDecoration(
          hintText: 'Search equipment...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          icon: Icon(Icons.search, size: 20, color: theme.colorScheme.primary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _updateFilters({"query": _searchController.text}),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
