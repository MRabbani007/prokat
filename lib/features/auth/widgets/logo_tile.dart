import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildMainRedirectTile(BuildContext context) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () => context.go('/main'),
    child: Row(
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
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.04 * 22,
                  color: Color(0xFF1A1A2E),
                ),
                children: [
                  TextSpan(text: 'PRO'),
                  TextSpan(
                    text: 'KAT',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
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
      ],
    ),
  );
}
