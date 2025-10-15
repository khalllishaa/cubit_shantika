abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favorites;
  FavoriteLoaded({required this.favorites});
}

class FavoriteToggled extends FavoriteState {}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError({required this.message});
}
