import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 24,
      child: Column(
        children: [
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
