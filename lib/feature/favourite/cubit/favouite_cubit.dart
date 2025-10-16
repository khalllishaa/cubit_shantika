import 'package:cubit_shantika/data/db/favourite_db.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/game_models.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  FavoriteCubit() : super(FavoriteInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      emit(FavoriteLoading());
      final favorites = await _dbHelper.getAllFavorites();
      print('Loaded ${favorites.length} favorites from database');
      favorites.forEach((fav) => print('  - ${fav['name']} (ID: ${fav['id']})'));
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      print('Error loading favorites: $e');
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> toggleFavorite({
    required int id,
    required String name,
    required List<GameGenre>? genres,
    double? rating,
    String? backgroundImage,
  }) async {
    try {
      print('Toggle favorite: $name (ID: $id)');

      final isFav = await _dbHelper.isFavorite(id);
      print('Current state - Is favorite: $isFav');

      if (isFav) {
        print('Removing from favorites...');
        await _dbHelper.removeFavorite(id);
        print('Removed successfully');
      } else {
        print('Adding to favorites...');
        final genreString = genres?.map((g) => g.name).join(', ') ?? 'Unknown';
        print('   Data to save: name=$name, genres=$genreString, rating=$rating');

        await _dbHelper.addFavorite({
          'id': id,
          'name': name,
          'genres': genreString,
          'rating': rating,
          'backgroundImage': backgroundImage,
          'addedAt': DateTime.now().toIso8601String(),
        });
        print('Added successfully');
      }

      // Reload dan emit
      final favorites = await _dbHelper.getAllFavorites();
      print('Total favorites after toggle: ${favorites.length}');
      favorites.forEach((fav) => print('  - ${fav['name']} (ID: ${fav['id']})'));

      final favoriteIds = favorites.map((fav) => fav['id'] as int).toSet();
      emit(FavoriteToggled(favoriteIds: favoriteIds));
    } catch (e) {
      print(e.toString());
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<bool> isFavorite(int id) async {
    return await _dbHelper.isFavorite(id);
  }
}