import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/features/layout/prokat_navigation_bar.dart';
// import 'package:prokat/features/layout/prokat_navigation_bar.dart';
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
      drawer: const SidebarDrawer(),
      bottomNavigationBar: const ProkatNavigationBar(),
      body: navigationShell,
    );
  }
}
