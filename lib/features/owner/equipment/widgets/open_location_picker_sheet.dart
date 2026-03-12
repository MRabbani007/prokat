import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void openLocationPickerSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Select Location",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 20),

            /// Saved Addresses
            _LocationActionTile(
              icon: Icons.history_rounded,
              title: "Saved Addresses",
              subtitle: "Pick from your frequently used spots",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses");
              },
            ),

            /// Add Address Manually
            _LocationActionTile(
              icon: Icons.add_home_work_rounded,
              title: "Enter New Address",
              subtitle: "Type in the address details manually",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses/create");
              },
            ),

            /// Pick on Map
            _LocationActionTile(
              icon: Icons.explore_rounded,
              title: "Pick on Map",
              subtitle: "Drag a pin to the exact location",
              onTap: () {
                Navigator.pop(context);
                context.push("/owner/addresses/map");
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

/// Sheet Row
class _LocationActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LocationActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}