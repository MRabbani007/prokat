import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/widgets/page_header.dart';

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
      backgroundColor: const Color(0xFF121417), // Deep Midnight
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2125), // Industrial Charcoal
              borderRadius: BorderRadius.circular(28), // Large Item Radius
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08), // Rim Lighting
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageHeader(title: title),
                const SizedBox(height: 32),

                // Icon using the Amber/Warning accent
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: const Color(0xFFD97706),
                ),

                const SizedBox(height: 24),

                // Secondary Label Style
                Text(
                  'HARDWARE RESTRICTION',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3), // Ghost Gray
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                // Primary Info Style
                const Text(
                  'Map view is available on mobile devices only.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // Pure White
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                // Primary Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(redirectRoute),
                    icon: const Icon(Icons.list_alt_rounded),
                    label: Text(
                      redirectLabel.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF4E73DF,
                      ), // Industrial Blue
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // Small Item Radius
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
