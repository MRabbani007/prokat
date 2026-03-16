import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapContainer extends StatelessWidget {
  final Widget mobileMap;
  final String redirectRoute;
  final String redirectLabel;
  final String title;

  const MapContainer({
    super.key,
    required this.mobileMap,
    required this.redirectRoute,
    required this.redirectLabel,
    required this.title,
  });

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    if (_isMobile) {
      return mobileMap;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
                context.go(redirectRoute);
              },
              icon: const Icon(Icons.list),
              label: Text(redirectLabel),
            ),
          ],
        ),
      ),
    );
  }
}