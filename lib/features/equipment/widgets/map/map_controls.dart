import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';

class MapControls extends ConsumerWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onChangeLocation;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onChangeLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Positioned(
      right: 12,
      top: 24,
      child: Column(
        children: [
          // New List View Button
          FloatingActionButton(
            heroTag: 'view-list',
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              final id = selectedCategory?.id ?? '';
              context.go('/search/list?category=$id');
            },
            child: const Icon(Icons.list),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'zoom-in',
            mini: true,
            onPressed: onZoomIn,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom-out',
            mini: true,
            onPressed: onZoomOut,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'change-location',
            onPressed: onChangeLocation,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
