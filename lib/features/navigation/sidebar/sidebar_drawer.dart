import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/core/router/app_routes.dart';

import 'sidebar_header.dart';
import 'sidebar_item.dart';
import 'sidebar_profile_tile.dart';
import 'sidebar_menu_config.dart';

class SidebarDrawer extends ConsumerWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final isLoggedIn = authState.isAuthenticated;
    final user = authState.session?.user;
    final role = user?.role;

    final menu = <SidebarMenuItem>[
      ...publicMenu,
      if (isLoggedIn) ...userMenu,
      if (role == 'OWNER') ...ownerMenu,
    ];

    return Drawer(
      child: Column(
        children: [
          const SidebarHeader(),

          const SizedBox(height: 12),

          /// Dynamic menu
          for (final item in menu)
            SidebarItem(
              icon: item.icon,
              label: item.label,
              route: item.route,
            ),

          const Spacer(),

          const Divider(),

          /// Profile tile
          if (isLoggedIn)
            SidebarProfileTile(
              username: user?.username ?? 'User',
              role: role,
            ),

          if (isLoggedIn) const Divider(),

          /// Settings
          if (isLoggedIn)
            SidebarItem(
              icon: Icons.settings_rounded,
              label: "Settings",
              route: AppRoutes.settings,
            )
          else ...[
            SidebarItem(
              icon: Icons.login_rounded,
              label: "Sign In",
              route: AppRoutes.login,
            ),
            SidebarItem(
              icon: Icons.rocket_launch_rounded,
              label: "Get Started",
              route: AppRoutes.register,
            ),
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}