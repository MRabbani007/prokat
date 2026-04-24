import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class BalanceTile extends StatelessWidget {
  final int minutes;
  final String burnRate;
  final double progress;
  final VoidCallback onTopUp;

  const BalanceTile({
    super.key,
    required this.minutes,
    required this.burnRate,
    required this.progress,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Title + Plus Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Minutes Balance",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Compact Top Up Button
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.ownerPaymentTopUp);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: colorScheme.primary, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Main Balance: Clickable area
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push(
                    AppRoutes.ownerPayment,
                  ), // Navigates to payments
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$minutes",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Min",
                        style: TextStyle(
                          fontSize: 18,
                          color: colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Burn Rate Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Burn Rate",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    burnRate,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary, // Primary fill
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
