import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OwnerChatInfoScreen extends ConsumerWidget {
  final String? chatId;
  const OwnerChatInfoScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onPrimary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              "Order Details",
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(theme, "Booking Info", [
                  _buildListTile(theme, "Order ID", "#ORD-8820"),
                  _buildListTile(theme, "Status", "In Progress", valueColor: Colors.orange),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection(theme, "Client Details", [
                  _buildListTile(theme, "Name", "John Doe"),
                  _buildListTile(theme, "Rating", "⭐ 4.9 (12 Rentals)"),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection(theme, "Payment", [
                  _buildListTile(theme, "Rental Fee", "\$400.00"),
                  _buildListTile(theme, "Insurance", "\$50.00"),
                  const Divider(height: 1),
                  _buildListTile(theme, "Total Paid", "\$450.00", isBold: true),
                ]),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () { /* Logic to complete job */ },
                    child: const Text("Mark Job as Completed"),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile(ThemeData theme, String title, String value, {Color? valueColor, bool isBold = false}) {
    return ListTile(
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor)),
      trailing: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          color: valueColor ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
