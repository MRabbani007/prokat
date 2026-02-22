import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildSectionHeader("Account & Documents"),
          _buildSettingTile(
            icon: Icons.description_outlined,
            title: "Invoicing & VAT Details",
            subtitle: "Manage company tax info for rentals",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.verified_user_outlined,
            title: "Operator Licenses",
            subtitle: "Upload required certifications",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("Preferences"),
          SwitchListTile(
            secondary: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.orange,
            ),
            title: const Text("Rental Updates"),
            subtitle: const Text("Status changes & delivery alerts"),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text("App Language"),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: _showLanguagePicker,
          ),
          SwitchListTile(
            secondary: const Icon(
              Icons.dark_mode_outlined,
              color: Colors.orange,
            ),
            title: const Text("Dark Mode"),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),

          const Divider(),
          _buildSectionHeader("Legal & Privacy"),
          _buildSettingTile(
            icon: Icons.policy_outlined,
            title: "Terms of Service",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.delete_forever_outlined,
            title: "Delete Account",
            textColor: Colors.red,
            onTap: () => _showDeleteConfirmation(),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              "App Version 1.0.4 (Build 2026)",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.orange),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['English', 'Қазақша', 'Русский']
            .map(
              (lang) => ListTile(
                title: Text(lang),
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text(
          "This action cannot be undone. All rental history will be lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
