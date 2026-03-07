import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/auth/providers/auth_state.dart';

class SidebarDrawer extends ConsumerWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final isLoggedIn = auth.status == AuthStatus.authenticated;
    final user = auth.session?.user;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(isLoggedIn, user?.displayName, user?.username),

          const SizedBox(height: 12),

          /// MAIN NAVIGATION
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
            icon: Icons.local_shipping_rounded,
            label: 'My Rentals',
            route: AppRoutes.myRentals,
          ),

          const Spacer(),
          const Divider(height: 1, color: Colors.black12),

          /// AUTH AREA
          if (isLoggedIn) ...[
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

            /// LOGOUT
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);

                await ref.read(authProvider.notifier).logout();

                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
            ),
          ] else ...[
            _item(
              context,
              icon: Icons.login_rounded,
              label: 'Sign In',
              route: AppRoutes.login,
            ),
            _item(
              context,
              icon: Icons.rocket_launch_rounded,
              label: 'Get Started',
              route: AppRoutes.register,
            ),
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// HEADER
  Widget _buildHeader(bool isLoggedIn, String? name, String? username) {
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
          /// APP ICON
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

          /// APP NAME
          const Text(
            'PROKAT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          /// USER INFO
          if (isLoggedIn) ...[
            Text(
              name ?? "User",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            if (username != null)
              Text(
                "@$username",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ] else ...[
            const Text(
              'Heavy Equipment Rentals',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// NAV ITEM
  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
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
      hoverColor: Colors.orange.withAlpha(10),
      onTap: () {
        Navigator.pop(context);
        context.push(route);
      },
    );
  }
}
