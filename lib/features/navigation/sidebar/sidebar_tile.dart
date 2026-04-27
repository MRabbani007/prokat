import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const SidebarTile({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      visualDensity: VisualDensity.compact,
    );
  }
}
