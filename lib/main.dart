import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:prokat/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
    "pk.eyJ1IjoibXJhYmJhbmkwMDciLCJhIjoiY21tOHE5N21lMTBlZDJ1cXVpZTBra2JyZyJ9.gHYXieEcDJiq81xN4oodvw",
  );

  runApp(const ProviderScope(child: MyApp()));
}
