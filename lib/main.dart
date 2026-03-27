import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/app.dart';

// This line handles the platform check at compile time
import 'package:prokat/map_setup_stub.dart'
    if (dart.library.io) 'package:prokat/setup_mapbox.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // This will call the real function on Mobile and the empty stub on Web
  setupMapbox();

  runApp(const ProviderScope(child: MyApp()));
}

// class AppInitializer extends ConsumerWidget {
//   final Widget child;

//   const AppInitializer({required this.child, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final profileAsync = ref.watch(userProfileProvider);

//     return profileAsync.when(
//       loading: () => const SplashScreen(),
//       error: (e, _) => ErrorScreen(e),
//       data: (_) => child,
//     );
//   }
// }

// AppInitializer(
//   child: MyApp(),
// )
