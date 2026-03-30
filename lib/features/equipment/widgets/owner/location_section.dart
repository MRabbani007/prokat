import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String? location;
  final VoidCallback onAction;

  const LocationSection({
    super.key,
    required this.location,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF1E2125);
    const ghostGray = Color(0x4DFFFFFF); // White @ 30%
    const accentBlue = Color(0xFF4E73DF);
    const warningAmber = Color(0xFFD97706);

    final bool hasLocation = location != null && location!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28), // Large Item Radius
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ), // Rim Light
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                    color: ghostGray,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                IconButton(
                  onPressed: onAction,
                  icon: Icon(
                    hasLocation
                        ? Icons.layers_outlined
                        : Icons.add_location_alt_rounded,
                    color: accentBlue,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Location Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.2,
                ), // Recessed "Terminal" look
                borderRadius: BorderRadius.circular(16), // Small Item Radius
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Icon(
                    hasLocation
                        ? Icons.fmd_good_rounded
                        : Icons.location_disabled_rounded,
                    color: hasLocation ? accentBlue : warningAmber,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasLocation
                              ? "CURRENT COORDINATES"
                              : "STATUS: UNKNOWN",
                          style: TextStyle(
                            color: hasLocation
                                ? ghostGray
                                : warningAmber.withValues(alpha: 0.7),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location ?? "GEOSPATIAL DATA MISSING",
                          style: TextStyle(
                            color: hasLocation ? Colors.white : warningAmber,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: hasLocation ? null : 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
