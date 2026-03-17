import 'package:flutter/material.dart';
import 'package:prokat/core/widgets/page_header.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121417); // Matches Sidebar
    const cardColor = Color(0xFF1E2125); // Slightly lighter for depth
    const accentColor = Color(0xFF4E73DF); // Industrial Blue

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reusable Page Header (Customized for clearing FAB)
              const PageHeader(title: "My Profile"),

              const SizedBox(height: 20),

              // 1. Profile Photo Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('https://via.placeholder.com'), // Replace with actual user photo
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              
              const Center(
                child: Text(
                  "John Doe", // Replace with dynamic name
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 32),

              // 2. Info Section (Cards)
              _buildInfoTile(
                icon: Icons.phone_android_rounded,
                label: "Phone Number",
                value: "+1 234 567 890",
                cardColor: cardColor,
              ),
              _buildInfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: "john.doe@example.com",
                cardColor: cardColor,
              ),
              _buildInfoTile(
                icon: Icons.location_on_outlined,
                label: "Primary Address",
                value: "123 Industrial Way, New York, NY",
                cardColor: cardColor,
              ),

              const SizedBox(height: 40),
              
              // Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: accentColor.withOpacity(0.4),
                    ),
                    child: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color cardColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4E73DF), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
