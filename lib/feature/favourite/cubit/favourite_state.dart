abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favorites;
  final Set<int> favoriteIds; // Tambahkan ini

  FavoriteLoaded({required this.favorites})
      : favoriteIds = favorites.map((fav) => fav['id'] as int).toSet();
}

class FavoriteToggled extends FavoriteState {
  final Set<int> favoriteIds; // Tambahkan ini
  FavoriteToggled({required this.favoriteIds});
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError({required this.message});
}