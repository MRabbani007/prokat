import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    const errorColor = Color(0xFFE53935);
    const ghostGray = Color(0x4DFFFFFF);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(
          0xFF1A1D21,
        ), // Slightly lighter than bgColor for depth
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: ghostGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: ghostGray, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: errorColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ref.read(authProvider.notifier).logout();

    if (context.mounted) {
      context.go('/login'); // Usually redirect to login after logout
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    const errorColor = Color(0xFFE53935);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: authState.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(errorColor),
              ),
            )
          : const Icon(Icons.logout_rounded, color: errorColor),
      title: const Text(
        "Logout",
        style: TextStyle(
          color: errorColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      onTap: authState.isLoading ? null : () => _confirmLogout(context, ref),
    );
  }
}
