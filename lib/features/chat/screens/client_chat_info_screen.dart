import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClientChatInfoScreen extends ConsumerWidget {
  final String? chatId;
  const ClientChatInfoScreen({super.key, this.chatId});

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
              "Chat Info",
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildAvatarSection(theme),
                const SizedBox(height: 32),
                _buildInfoSection(theme, "Booking Info", [
                  _buildListTile(theme, "Reference", "#REQ-9912"),
                  _buildListTile(theme, "Status", "Active", valueColor: Colors.green),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection(theme, "Owner Details", [
                  _buildListTile(theme, "Name", "Owner Name"),
                  _buildListTile(theme, "Rating", "⭐ 4.8 (24 Reviews)"),
                ]),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text("Report Issue"),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(ThemeData theme) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=Owner"),
        ),
        const SizedBox(height: 16),
        Text(
          "Owner Name",
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "Equipment Owner",
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
        ),
      ],
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

  Widget _buildListTile(ThemeData theme, String title, String value, {Color? valueColor}) {
    return ListTile(
      title: Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor)),
      trailing: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: valueColor ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
