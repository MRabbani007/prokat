import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prokat/core/router/app_routes.dart';

class SidebarProfileTile extends StatelessWidget {
  final String username;
  final String? role;

  const SidebarProfileTile({super.key, required this.username, this.role});

  bool get showRole => role == 'owner' || role == 'admin';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_rounded, color: Colors.indigo),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: showRole
          ? Text(
              role!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        context.go(AppRoutes.profile);
      },
    );
  }
}
