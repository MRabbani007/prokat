import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:prokat/core/api/api_client.dart';
// import 'package:prokat/core/storage/secure_storage.dart';
// import 'package:prokat/screens/heatlth_check_screen.dart'; // Import the screen from previous step

// // 1. Define the providers
// final storageProvider = Provider((ref) => const FlutterSecureStorage());
// final secureStorageProvider = Provider((ref) => SecureStorage());
// final apiClientProvider = Provider(
//   (ref) => ApiClient(ref.read(secureStorageProvider)),
// );

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const ProviderScope(child: HealthTestApp()));
// }

// // 2. A temporary wrapper to show the HealthCheckScreen immediately
// class HealthTestApp extends ConsumerWidget {
//   const HealthTestApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final apiClient = ref.watch(apiClientProvider);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(useMaterial3: true),
//       // This bypasses your router and goes straight to the test screen
//       home: HealthCheckScreen(apiClient: apiClient),
//     );
//   }
// }
