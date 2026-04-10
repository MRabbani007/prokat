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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardColor = colorScheme.surfaceContainerHighest;
    final ghostGray = colorScheme.onSurface.withValues(alpha: 0.6);
    final accent = colorScheme.primary;
    final warning = colorScheme.tertiary;

    final bool hasLocation = location != null && location!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LOCATION",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: ghostGray,
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
                    color: accent,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasLocation
                        ? Icons.fmd_good_rounded
                        : Icons.location_disabled_rounded,
                    color: hasLocation ? accent : warning,
                    size: 20,
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasLocation
                              ? "CURRENT LOCATION"
                              : "NO LOCATION SET",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: hasLocation
                                ? ghostGray
                                : warning.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location ?? "Add a location to enable bookings",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: hasLocation
                                ? colorScheme.onSurface
                                : warning,
                            fontWeight: FontWeight.w600,
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