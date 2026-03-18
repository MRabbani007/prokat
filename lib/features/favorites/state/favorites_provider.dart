import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/core/providers/api_provider.dart';
import 'package:prokat/features/favorites/state/favorites_notifier.dart';
import 'package:prokat/features/favorites/state/favorites_service.dart';

final favoriteServiceProvider = Provider((ref) {
  final dio = ref.watch(apiClientProvider);

  return FavoriteService(dio); 
});

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, AsyncValue<Set<String>>>((ref) {
  final service = ref.read(favoriteServiceProvider);
  return FavoriteNotifier(service);
});
