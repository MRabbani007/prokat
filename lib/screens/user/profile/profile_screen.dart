import 'package:flutter/material.dart';

// [Full implementation code provided in source 1.1.6]
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            _buildSectionHeader("Company Details"),
            _buildProfileTile(Icons.business, "Company Name", "Example Corp"),
            _buildSectionHeader("Payment Methods"),
            _buildProfileTile(Icons.credit_card, "Saved Card", "**** 4421"),
            _buildSectionHeader("Support"),
            _buildProfileTile(
              Icons.logout,
              "Logout",
              "Sign out",
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Text(title.toUpperCase());
  Widget _buildProfileTile(
    IconData icon,
    String title,
    String subtitle, {
    Color? textColor,
  }) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}
