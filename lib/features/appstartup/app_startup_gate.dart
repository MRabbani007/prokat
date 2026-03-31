import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/appstartup/app_startup_provider.dart';
import 'package:prokat/features/appstatic/screens/error_screen.dart';
import 'package:prokat/features/appstatic/screens/launch_screen.dart';

class AppStartupGate extends ConsumerStatefulWidget {
  const AppStartupGate({super.key});

  @override
  ConsumerState<AppStartupGate> createState() => _AppStartupGateState();
}

class _AppStartupGateState extends ConsumerState<AppStartupGate> {
  @override
  void initState() {
    super.initState();

    // ✅ Runs ONLY ONCE
    Future.microtask(() {
      ref.read(appStartupProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStartupProvider);

    switch (state) {
      case AppStartupState.loading:
        return const LaunchScreen();

      case AppStartupState.guest:
      // return const AuthScreen();

      case AppStartupState.renter:
      // return const RenterApp();

      case AppStartupState.owner:
        // return const OwnerApp();

        return LaunchScreen();

      case AppStartupState.error:
        return const ErrorScreen();
    }
  }
}
