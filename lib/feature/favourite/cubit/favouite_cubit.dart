import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:cubit_shantika/repository/favourite_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/game_models.dart';
import '../../../utils/data_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(FavoriteInitial()) {
    loadFavorites();
  }

  // LOAD ALL FAVORITES
  Future<void> loadFavorites() async {
    emit(FavoriteLoading());

    final result = await _repository.getAllFavorites();

    if (result is DataStateSuccess<List<Map<String, dynamic>>>) {
      emit(FavoriteLoaded(favorites: result.data ?? []));
    } else if (result is DataStateError) {
      emit(FavoriteError(message: result.exception?.message ?? "Unknown error"));
    }
  }

  // CHECK IS FAVORITE
  Future<bool> isFavorite(int id) async {
    final result = await _repository.isFavorite(id);
    if (result is DataStateSuccess<bool>) {
      return result.data ?? false;
    }
    return false;
  }

  // TOGGLE FAVORITE
  Future<void> toggleFavorite({
    required int id,
    required String name,
    required List<GameGenre>? genres,
    double? rating,
    String? backgroundImage,
  }) async {
    final result = await _repository.isFavorite(id);

    if (result is DataStateSuccess<bool>) {
      final isFav = result.data ?? false;

      if (isFav) {
        // REMOVE
        final removeResult = await _repository.removeFavorite(id);
        if (removeResult.exception != null) {
          emit(FavoriteError(message: removeResult.exception?.message ?? "Unknown error"));
          return;
        }
      } else {
        // ADD
        final genreString = genres?.map((g) => g.name).join(', ') ?? 'Unknown';
        final gameData = {
          'id': id,
          'name': name,
          'genres': genreString,
          'rating': rating,
          'backgroundImage': backgroundImage,
          'addedAt': DateTime.now().toIso8601String(),
        };

        final addResult = await _repository.addFavorite(gameData);
        if (addResult.exception != null) {
          emit(FavoriteError(message: addResult.exception?.message ?? "Unknown error"));
          return;
        }
      }

      // RELOAD LIST
      final favResult = await _repository.getAllFavorites();
      if (favResult is DataStateSuccess<List<Map<String, dynamic>>>) {
        final favorites = (favResult.data ?? []);
        final favoriteIds = favorites.map((fav) => fav['id'] as int).toSet();
        emit(FavoriteToggled(favoriteIds: favoriteIds));
      } else if (favResult is DataStateError) {
        emit(FavoriteError(message: favResult.exception?.message ?? "Unknown error"));
      }
    } else if (result is DataStateError) {
      emit(FavoriteError(message: result.exception?.message ?? "Unknown error"));
    }
  }
}
