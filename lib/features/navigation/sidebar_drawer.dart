import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Changed to a clean light background to match the main pages
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // 1. Branding Header
          _buildHeader(),

          const SizedBox(height: 12),

          // 2. Navigation Items
          _item(
            context,
            icon: Icons.home_rounded,
            label: 'Home',
            route: AppRoutes.main,
          ),
          _item(
            context,
            icon: Icons.search_rounded,
            label: 'Search',
            route: AppRoutes.searchList,
          ),
          _item(
            context,
            icon: Icons.favorite_rounded,
            label: 'Favorites',
            route: AppRoutes.favorites,
          ),
          _item(
            context,
            icon: Icons.local_shipping_rounded, // Changed for "Rentals" feel
            label: 'My Rentals',
            route: AppRoutes.myRentals,
          ),

          const Spacer(),

          const Divider(height: 1, color: Colors.black12),

          // 3. Footer Items
          _item(
            context,
            icon: Icons.person_rounded,
            label: 'Profile',
            route: AppRoutes.profile,
          ),
          _item(
            context,
            icon: Icons.settings_rounded,
            label: 'Settings',
            route: AppRoutes.settings,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        border: const Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dummy Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          // App Name
          const Text(
            'PROKAT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black87,
            ),
          ),
          const Text(
            'Heavy Equipment Rentals',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    // Check if this is the current route to highlight it (Optional logic)
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      // Added a subtle hover/press color
      hoverColor: Colors.orange.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context); // close drawer
        context.go(route);
      },
    );
  }
}
