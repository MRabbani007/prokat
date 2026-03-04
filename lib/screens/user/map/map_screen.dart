// lib/screens/user/map/map_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

import 'mobile_map_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    if (_isMobile) {
      return const MobileMapScreen(mode: MapMode.browseEquipment);
    }

    // Web / Desktop fallback
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Map view is available on mobile devices only.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.searchList);
              },
              child: const Text('View as list'),
            ),
          ],
        ),
      ),
    );
  }
}
