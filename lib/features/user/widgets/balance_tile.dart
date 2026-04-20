import 'package:flutter/material.dart';

class BalanceTile extends StatelessWidget {
  final int minutes;
  final String burnRate;
  final double progress; // 0.0 to 1.0
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary, // Using your deep blue/primary
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Minutes Balance",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight(600),
              color: theme.colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "142",
                      style: TextStyle(
                        fontSize: 20,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Min",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Burn Rate",
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  Text(
                    "1min / hr Online",
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ],
          ),

          // Custom Progress Bar
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Top up Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onTopUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onPrimary,
                foregroundColor: theme.colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Top up minutes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
