import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/auth/providers/auth_provider.dart';
import 'package:prokat/features/categories/providers/category_provider.dart';
import 'package:prokat/features/navigation/sidebar/sidebar_tile.dart';
import 'sidebar_header.dart';
import 'package:go_router/go_router.dart';

class SidebarDrawer extends ConsumerWidget {
  const SidebarDrawer({super.key});

  IconData _getCategoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('septic')) return Icons.local_shipping_rounded;
    if (n.contains('truck')) return Icons.fire_truck_rounded;
    if (n.contains('excavator')) return Icons.precision_manufacturing_rounded;
    return Icons.construction_rounded;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bgColor = Color(0xFF121417);
    // const accentColor = Color(0xFF4E73DF);

    final authState = ref.watch(authProvider);
    final categoriesState = ref.watch(categoriesProvider);

    final isLoggedIn = authState.isAuthenticated;
    final user = authState.session?.user;
    final isOwner = user?.role == "OWNER" || user?.role == "ADMIN";

    // final menu = <SidebarMenuItem>[
    //   ...publicMenu,
    //   if (isLoggedIn) ...userMenu,
    //   if (role == 'OWNER') ...ownerMenu,
    // ];

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SidebarHeader(), // Assumed custom header

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 10),
                // SECTION: SERVICES

                // MAIN SELECTED SERVICE
                _ActiveServiceTile(
                  title:
                      categoriesState.selectedCategory?.name ??
                      "Select Service",
                  icon: categoriesState.selectedCategory?.name != null
                      ? _getCategoryIcon(
                          categoriesState.selectedCategory?.name ?? "",
                        )
                      : Icons.local_shipping_rounded,
                  onTap: () => context.go(AppRoutes.categories),
                ),

                SidebarTile(
                  icon: Icons.home,
                  label: "Dashboard",
                  route: "/dashboard",
                ),
                SidebarTile(
                  icon: Icons.search,
                  label: "Search",
                  route: AppRoutes.searchMap,
                ),
                SidebarTile(
                  icon: Icons.ads_click,
                  label: "My Requests",
                  route: AppRoutes.myRequests,
                ),
                SidebarTile(
                  icon: Icons.favorite_border,
                  label: "Favorites",
                  route: AppRoutes.favorites,
                ),
                SidebarTile(
                  icon: Icons.calendar_month_outlined,
                  label: "My Orders",
                  route: AppRoutes.myOrders,
                ),

                if (isOwner) ...[
                  const SizedBox(height: 32),

                  // SECTION: OWNER (Conditional logic can be added here)

                  SidebarTile(
                    icon: Icons.construction,
                    label: "Equipment",
                    route: AppRoutes.ownerEquiment,
                  ),
                  SidebarTile(
                    icon: Icons.book_online_outlined,
                    label: "Bookings",
                    route: AppRoutes.ownerBookings,
                  ),
                  SidebarTile(
                    icon: Icons.message_outlined,
                    label: "Requests",
                    route: AppRoutes.ownerRequests,
                  ),
                ],
              ],
            ),
          ),

          // BOTTOM SECTION: PROFILE & SETTINGS
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(3),
              border: Border(
                top: BorderSide(color: Colors.white.withAlpha(10)),
              ),
            ),
            child: isLoggedIn
                ? Column(
                    children: [
                      SidebarTile(
                        icon: Icons.person_outline,
                        label: "Profile",
                        route: "/profile",
                      ),
                      SidebarTile(
                        icon: Icons.settings_outlined,
                        label: "Settings",
                        route: "/settings",
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : Column(
                    children: [
                      SidebarTile(
                        icon: Icons.person_outline,
                        label: "Login",
                        route: "/login",
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActiveServiceTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActiveServiceTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withAlpha(30)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
          size: 18,
        ),
      ),
    );
  }
}
