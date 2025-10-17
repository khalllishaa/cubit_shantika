import 'package:cubit_shantika/data/api_service.dart';
import 'package:cubit_shantika/models/game_models.dart';
import 'package:cubit_shantika/models/response/game_response.dart';
import 'package:cubit_shantika/repository/base/base_repository.dart';

import '../config/constant.dart';
import '../utils/data_state.dart';

class GameRepository extends BaseRepository {
  final ApiService _apiService;

  GameRepository(this._apiService);

  /// Fetch games dengan pagination
  Future<List<GameModel>> fetchGames({required int page}) async {
    final dataState = await getStateOf<GamesResponse>(
      request: () => _apiService.getGames(page: page),
    );

    if (dataState is DataStateSuccess) {
      return dataState.data!.results;
    } else {
      throw Exception('Failed to fetch games');
    }
  }

  /// Search games
  Future<List<GameModel>> searchGames({
    required String query,
    int page = 1,
    int pageSize = AppConfig.defaultPageSize,
  }) async {
    try {
      final dataState = await getStateOf<GamesResponse>(
        request: () => _apiService.searchGames(
          search: query,
          page: page,
          pageSize: pageSize,
        ),
      );

      if (dataState is DataStateSuccess) {
        return dataState.data!.results;
      } else {
        throw Exception('Failed to search games');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  /// Get game detail
  Future<GameModel> getDetail(int id) async {
    try {
      final dataState = await getStateOf<GameModel>(
        request: () => _apiService.getGameDetail(id: id),
      );

      if (dataState is DataStateSuccess) {
        return dataState.data!;
      } else {
        throw Exception('Failed to fetch game detail');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}