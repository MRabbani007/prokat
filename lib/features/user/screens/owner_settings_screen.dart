import 'package:flutter/material.dart';

class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Owner Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Availability", theme),
          _card([
            _switchTile("Auto-accept bookings", true, (v) {}),
            _switchTile("Allow same-day bookings", false, (v) {}),
            _tile("Minimum rental duration", "1 day", () {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Booking Preferences", theme),
          _card([
            _switchTile("Require approval", true, (v) {}),
            _switchTile("Allow instant booking", false, (v) {}),
            _tile("Advance notice", "2 hours", () {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Pricing Behavior", theme),
          _card([
            _switchTile("Enable dynamic pricing", false, (v) {}),
            _switchTile("Weekend price adjustment", true, (v) {}),
            _tile("Security deposit", "\$100", () {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Notifications", theme),
          _card([
            _switchTile("New booking requests", true, (v) {}),
            _switchTile("Messages", true, (v) {}),
            _switchTile("Reminders", true, (v) {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Safety & Rules", theme),
          _card([
            _tile("Cancellation policy", "Moderate", () {}),
            _tile("Damage policy", "Standard coverage", () {}),
          ]),

          const SizedBox(height: 16),

          _sectionTitle("Danger Zone", theme),
          _card([
            _dangerTile("Deactivate account", () {}),
            _dangerTile("Delete account", () {}),
          ]),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: theme.textTheme.titleMedium),
    );
  }

  Widget _card(List<Widget> children) {
    return Card(child: Column(children: children));
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _tile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _dangerTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.red)),
      onTap: onTap,
    );
  }
}
