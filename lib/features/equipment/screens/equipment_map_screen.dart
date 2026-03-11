// features/equipment/screens/equipment_map_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import 'mobile_equipment_map_screen.dart';

class EquipmentMapScreen extends StatelessWidget {
  const EquipmentMapScreen({super.key});

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    // ✅ Mobile: show real map
    if (_isMobile) {
      return const MobileEquipmentMapScreen();
    }

    // 🌐 Web / Desktop fallback
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Map')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Map view is available on mobile devices only.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.go(AppRoutes.searchList);
              },
              icon: const Icon(Icons.list),
              label: const Text('View as list'),
            ),
          ],
        ),
      ),
    );
  }
}
