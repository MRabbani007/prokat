import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      hoverColor: Colors.indigoAccent.withAlpha(60),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}