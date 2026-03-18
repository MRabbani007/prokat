import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prokat/features/favorites/state/favorites_service.dart';

class FavoriteNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  final FavoriteService service;

  FavoriteNotifier(this.service) : super(const AsyncLoading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await service.getFavorites();
      state = AsyncData(favorites);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  bool isFavorite(String id) {
    return state.valueOrNull?.contains(id) ?? false;
  }

  Future<void> toggle(String equipmentId) async {
    final current = state.valueOrNull ?? {};

    // 🔥 Optimistic update
    final isFav = current.contains(equipmentId);
    final updated = Set<String>.from(current);

    if (isFav) {
      updated.remove(equipmentId);
    } else {
      updated.add(equipmentId);
    }

   await loadFavorites();

    // state = AsyncData(updated);

    try {
      await service.toggleFavorite(equipmentId);
    } catch (e) {
      // rollback
      state = AsyncData(current);
    }
  }
}
