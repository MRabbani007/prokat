import 'package:flutter/material.dart';

class OwnerPaymentsScreen extends StatelessWidget {
  const OwnerPaymentsScreen({super.key});

  /// Example values (replace with real state)
  final int balanceMinutes = 5760; // = 4 days
  final int balanceKzt = 1000;
  final int equipmentCount = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final humanReadable = _formatMinutes(balanceMinutes);
    final burnRate = _calculateDailyCost(equipmentCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payments & Balance"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _balanceCard(theme, humanReadable, burnRate),

          const SizedBox(height: 16),

          _usageCard(theme, burnRate),

          const SizedBox(height: 16),

          _topUpCard(context),

          const SizedBox(height: 16),

          _historySection(theme),
        ],
      ),
    );
  }

  /// 🔥 BALANCE CARD
  Widget _balanceCard(
    ThemeData theme,
    String humanReadable,
    int burnRate,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Balance", style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            Text(
              "$balanceMinutes min",
              style: theme.textTheme.headlineSmall,
            ),

            Text(
              humanReadable,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "$balanceKzt ₸",
              style: theme.textTheme.bodyLarge,
            ),

            const Divider(height: 24),

            Text(
              "Estimated time remaining: ${_estimateRemainingDays(burnRate)}",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// ⚡ USAGE CARD
  Widget _usageCard(ThemeData theme, int burnRate) {
    return Card(
      child: ListTile(
        title: Text("Active Equipment: $equipmentCount"),
        subtitle: Text("Daily cost: $burnRate ₸"),
        trailing: const Icon(Icons.insights),
      ),
    );
  }

  /// 💰 TOP UP
  Widget _topUpCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Top Up Balance"),
            const SizedBox(height: 12),

            Row(
              children: [
                _amountButton("500 ₸"),
                _amountButton("1000 ₸"),
                _amountButton("2000 ₸"),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _payWithKaspi();
                },
                child: const Text("Pay with Kaspi"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _amountButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: () {},
          child: Text(label),
        ),
      ),
    );
  }

  /// 📜 HISTORY
  Widget _historySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Payments", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),

        _historyTile("1000 ₸", "Apr 10"),
        _historyTile("500 ₸", "Apr 05"),
        _historyTile("2000 ₸", "Mar 28"),
      ],
    );
  }

  Widget _historyTile(String amount, String date) {
    return ListTile(
      title: Text(amount),
      subtitle: Text(date),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  /// ------------------------
  /// 🧠 LOGIC HELPERS
  /// ------------------------

  String _formatMinutes(int minutes) {
    final days = minutes ~/ 1440;
    final hours = (minutes % 1440) ~/ 60;

    if (days > 0) return "$days days $hours hours";
    return "$hours hours";
  }

  int _calculateDailyCost(int equipmentCount) {
    switch (equipmentCount) {
      case 1:
        return 60;
      case 2:
        return 110;
      case 3:
        return 150;
      default:
        return 150 + (equipmentCount - 3) * 40;
    }
  }

  String _estimateRemainingDays(int dailyCost) {
    if (dailyCost == 0) return "Unlimited";

    final days = balanceKzt ~/ dailyCost;
    return "$days days";
  }

  void _payWithKaspi() {
    /// TODO: integrate Kaspi payment
  }
}