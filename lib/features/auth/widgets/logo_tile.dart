import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildMainRedirectTile(BuildContext context) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () => context.go('/main'),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.construction_rounded,
            color: theme.primaryColor,
            size: 40,
          ),
        ),

        // const SizedBox(height: 12),

        // 2. Prokat (Brand Name)
        Text(
          "PROKAT",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: theme.colorScheme.onSurface,
          ),
        ),

        // 3. Slogan
        Text(
          "Equipment Renting".toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    ),
  );
}
