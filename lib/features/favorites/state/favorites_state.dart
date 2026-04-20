import 'package:prokat/features/equipment/models/equipment_model.dart';

class FavoritesState {
  final bool isLoading;
  final String? error;

  final Set<String>? favoritesIds;
  final List<Equipment>? favorites;

  FavoritesState({
    this.isLoading = false,
    this.error,
    this.favoritesIds,
    this.favorites,
  });

  FavoritesState copyWith({
    bool? isLoading,
    String? error,
    Set<String>? favoritesIds,
    List<Equipment>? favorites,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,

      favoritesIds: favoritesIds ?? this.favoritesIds,
      favorites: favorites ?? this.favorites,
    );
  }
}
