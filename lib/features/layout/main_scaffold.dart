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
                10, // Account for status bar
            left: 16,
            child: FloatingActionButton.small(
              heroTag:
                  'menu_fab', // Unique tag to avoid hero animation conflicts
              elevation: 2, // Keeps it subtle
              backgroundColor: Theme.of(context).colorScheme.surface,
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.primary,
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
