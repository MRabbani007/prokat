import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/router/app_routes.dart';
import 'package:prokat/features/appstartup/app_startup_provider.dart';
import 'package:prokat/features/auth/widgets/auth_button.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const bgColor = Color(0xFF121417);
    const ghostGray = Color(0x4DFFFFFF);
    const accentColor = Color(0xFF4E73DF);

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sync_problem_rounded, size: 80, color: accentColor),
            const SizedBox(height: 32),
            const Text(
              "INITIALIZATION ERROR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "We couldn't load your session or connection was lost. Please check your network and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: ghostGray, fontSize: 16),
            ),
            const SizedBox(height: 48),
            AuthButton(
              loading: false,
              text: "RETRY CONNECTION",
              loadingText: "RECONNECTING...",
              onPressed: () {
                // Reset the startup provider to trigger a fresh init()
                ref.read(appStartupProvider.notifier).init();
                // Redirect back to launch to restart the flow
                context.go(AppRoutes.launch);
              },
            ),
          ],
        ),
      ),
    );
  }
}
