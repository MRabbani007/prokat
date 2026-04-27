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
