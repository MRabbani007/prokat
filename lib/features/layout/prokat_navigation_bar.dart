import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class ProkatNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ProkatNavigationBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine the current tab based on the current URL
    final String location = GoRouterState.of(context).path ?? "";
    int currentIndex = 0;

    if (location.startsWith('/search/list')) {
      currentIndex = 1;
    } else if (location.startsWith('/requests/create')) {
      currentIndex = 2;
    } else if (location.startsWith('/bookings')) {
      currentIndex = 3;
    } else if (location.startsWith('/chats')) {
      currentIndex = 4;
    } else {
      currentIndex = 0; // default to dashboard
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.scaffoldBackgroundColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onBackground.withOpacity(0.5),
      iconSize: 32, // make the icons bigger
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/search/list');
            break;
          case 2:
            context.go('/requests/create');
            break;
          case 3:
            context.go(AppRoutes.booking);
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
      ],
    );
  }
}
