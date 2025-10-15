import 'package:cubit_shantika/data/db/favourite_db.dart';
import 'package:cubit_shantika/feature/favourite/cubit/favourite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class FavoriteCubit extends Cubit<FavoriteState> {
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;
//
//   FavoriteCubit() : super(FavoriteInitial());
//
//   Future<void> loadFavorites() async {
//     try {
//       emit(FavoriteLoading());
//       final favorites = await _dbHelper.getAllFavorites();
//       emit(FavoriteLoaded(favorites: favorites));
//     } catch (e) {
//       emit(FavoriteError(message: e.toString()));
//     }
//   }
//
//   Future<void> toggleFavorite({
//     required int id,
//     required String name,
//     double? rating,
//     String? backgroundImage,
//   }) async {
//     try {
//       final isFav = await _dbHelper.isFavorite(id);
//
//       if (isFav) {
//         await _dbHelper.removeFavorite(id);
//       } else {
//         await _dbHelper.addFavorite({
//           'id': id,
//           'name': name,
//           'rating': rating,
//           'backgroundImage': backgroundImage,
//           'addedAt': DateTime.now().toIso8601String(),
//         });
//       }
//
//       // Reload favorites
//       await loadFavorites();
//     } catch (e) {
//       emit(FavoriteError(message: e.toString()));
//     }
//   }
//
//   Future<bool> isFavorite(int id) async {
//     return await _dbHelper.isFavorite(id);
//   }
// }

class FavoriteCubit extends Cubit<FavoriteState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  FavoriteCubit() : super(FavoriteInitial());

  Future<void> loadFavorites() async {
    try {
      emit(FavoriteLoading());
      final favorites = await _dbHelper.getAllFavorites();
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> toggleFavorite({
    required int id,
    required String name,
    double? rating,
    String? backgroundImage,
  }) async {
    try {
      final isFav = await _dbHelper.isFavorite(id);

      if (isFav) {
        await _dbHelper.removeFavorite(id);
      } else {
        await _dbHelper.addFavorite({
          'id': id,
          'name': name,
          'rating': rating,
          'backgroundImage': backgroundImage,
          'addedAt': DateTime.now().toIso8601String(),
        });
      }

      // Emit state change to refresh UI
      emit(FavoriteToggled());
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<bool> isFavorite(int id) async {
    return await _dbHelper.isFavorite(id);
  }
}