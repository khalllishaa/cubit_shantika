import 'package:cubit_shantika/data/db/favourite_db.dart';
import 'package:cubit_shantika/repository/base/base_repository.dart';
import 'package:cubit_shantika/utils/data_state.dart';
import 'package:dio/dio.dart';

class FavoriteRepository extends BaseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<DataState<List<Map<String, dynamic>>>> getAllFavorites() async {
    try {
      final favorites = await _dbHelper.getAllFavorites();
      return DataStateSuccess(favorites);
    } catch (e) {
      return DataStateError(DioException(
        requestOptions: RequestOptions(),
        message: e.toString(),
      ));
    }
  }

  Future<DataState<bool>> isFavorite(int id) async {
    try {
      final result = await _dbHelper.isFavorite(id);
      return DataStateSuccess(result);
    } catch (e) {
      return DataStateError(DioException(
        requestOptions: RequestOptions(),
        message: e.toString(),
      ));
    }
  }

  Future<DataState<void>> addFavorite(Map<String, dynamic> game) async {
    try {
      await _dbHelper.addFavorite(game);
      return const DataStateSuccess(null);
    } catch (e) {
      return DataStateError(DioException(
        requestOptions: RequestOptions(),
        message: e.toString(),
      ));
    }
  }

  Future<DataState<void>> removeFavorite(int id) async {
    try {
      await _dbHelper.removeFavorite(id);
      return const DataStateSuccess(null);
    } catch (e) {
      return DataStateError(DioException(
        requestOptions: RequestOptions(),
        message: e.toString(),
      ));
    }
  }
}
