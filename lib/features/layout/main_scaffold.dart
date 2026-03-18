import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/navigation/sidebar/sidebar_drawer.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  MainScaffold({super.key, required this.navigationShell});

  // Scaffold key to control drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // appBar: MainAppBar(
      //   title: _resolveTitle(context),
      //   onMenuPressed: () {
      //     _scaffoldKey.currentState?.openDrawer();
      //   },
      // ),
      drawer: const SidebarDrawer(),

      body: Stack(
        children: [
          // The actual page content
          navigationShell,

          // The Custom Menu Button
          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                12, // Slightly more padding for balance
            left: 16,
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1E2125,
                  ), // Matches your SidebarTile color
                  borderRadius: BorderRadius.circular(
                    14,
                  ), // Industrial Squircle
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.08,
                    ), // Subtle rim light
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_rounded,
                    color: const Color(
                      0xFF4E73DF,
                    ), // Your Industrial Blue accent
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simple title resolver (safe, replace later with route metadata)
  // String _resolveTitle(BuildContext context) {
  //   final location = GoRouterState.of(context).uri.path;

  //   if (location.startsWith('/home')) return 'Home';
  //   if (location.startsWith('/search')) return 'Search';
  //   if (location.startsWith('/equipment')) return 'Equipment';
  //   if (location.startsWith('/booking')) return 'Booking';
  //   if (location.startsWith('/myrentals')) return 'My Rentals';
  //   if (location.startsWith('/favorites')) return 'Favorites';
  //   if (location.startsWith('/profile')) return 'Profile';
  //   if (location.startsWith('/settings')) return 'Settings';

  //   if (location.startsWith('/owner/dashboard')) return 'Dashboard';
  //   if (location.startsWith('/owner/equipment')) return 'My Equipment';
  //   if (location.startsWith('/owner/bookings')) return 'Bookings';
  //   if (location.startsWith('/owner/profile')) return 'Owner Profile';
  //   if (location.startsWith('/owner/settings')) return 'Owner Settings';

  //   return 'Prokat';
  // }
}
