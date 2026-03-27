class FavoritesState {
  final bool isLoading;
  final String? error;

  final Set<String>? favoritesIds;

  FavoritesState({
    this.isLoading = false,
    this.error,
    this.favoritesIds,
  });

  FavoritesState copyWith({
    bool? isLoading,
    String? error,
    Set<String>? favoritesIds,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,

      favoritesIds: favoritesIds ?? this.favoritesIds,
    );
  }
}
