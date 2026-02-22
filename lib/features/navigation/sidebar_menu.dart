import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class SidebarMenu extends StatelessWidget {
  final String currentPath;

  const SidebarMenu({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// Glass background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.black.withAlpha(50)),
            ),
          ),

          /// Drawer panel
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              decoration: const BoxDecoration(
                color: Color(0xFF0F0F0F),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // const SizedBox(height: 20),

                    // ───────── HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.indigoAccent,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Prokat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white38,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // ───────── MAIN MENU (scrollable)
                    Expanded(
                      flex: 1,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _MenuItem(
                            icon: Icons.dashboard_rounded,
                            label: 'Search',
                            isActive: currentPath == AppRoutes.searchList,
                            onTap: () =>
                                _navigate(context, AppRoutes.searchList),
                          ),
                          _MenuItem(
                            icon: Icons.check_circle_outline_rounded,
                            label: 'My Rentals',
                            isActive: currentPath == AppRoutes.myRentals,
                            onTap: () =>
                                _navigate(context, AppRoutes.myRentals),
                          ),
                          _MenuItem(
                            icon: Icons.monitor_heart_outlined,
                            label: 'Favorites',
                            isActive: currentPath == AppRoutes.favorites,
                            onTap: () =>
                                _navigate(context, AppRoutes.favorites),
                          ),
                        ],
                      ),
                    ),

                    // ───────── DIVIDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Divider(color: Colors.white.withAlpha(8)),
                    ),

                    // ───────── BOTTOM ACTIONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.person_outline_rounded,
                            label: 'Profile',
                            isActive: currentPath == AppRoutes.profile,
                            onTap: () => _navigate(context, AppRoutes.profile),
                          ),
                          _MenuItem(
                            icon: Icons.settings_rounded,
                            label: 'Settings',
                            isActive: currentPath == AppRoutes.settings,
                            onTap: () => _navigate(context, AppRoutes.settings),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.indigoAccent.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? Colors.indigoAccent.withOpacity(0.2)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.indigoAccent : Colors.white60,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
