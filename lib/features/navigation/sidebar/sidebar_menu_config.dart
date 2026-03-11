import 'package:flutter/material.dart';
import 'package:prokat/core/router/app_routes.dart';

class SidebarMenuItem {
  final String label;
  final IconData icon;
  final String route;

  const SidebarMenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

/// Public menu (everyone)
const List<SidebarMenuItem> publicMenu = [
  SidebarMenuItem(
    label: 'Home',
    icon: Icons.home_rounded,
    route: AppRoutes.main,
  ),
  SidebarMenuItem(
    label: 'Categories',
    icon: Icons.category,
    route: AppRoutes.categories,
  ),
  SidebarMenuItem(
    label: 'Search',
    icon: Icons.search_rounded,
    route: AppRoutes.searchMap,
  ),
];

/// Authenticated user menu
const List<SidebarMenuItem> userMenu = [
  SidebarMenuItem(
    label: 'Favorites',
    icon: Icons.favorite_rounded,
    route: AppRoutes.favorites,
  ),
  SidebarMenuItem(
    label: 'My Rentals',
    icon: Icons.local_shipping_rounded,
    route: AppRoutes.myRentals,
  ),
];

/// Owner menu
const List<SidebarMenuItem> ownerMenu = [
  SidebarMenuItem(
    label: 'My Equipment',
    icon: Icons.precision_manufacturing,
    route: AppRoutes.ownerEquiment,
  ),
  SidebarMenuItem(
    label: 'Bookings',
    icon: Icons.event_available,
    route: AppRoutes.ownerBookings,
  ),
  SidebarMenuItem(
    label: 'Requests',
    icon: Icons.request_page,
    route: AppRoutes.ownerRequests,
  ),
];