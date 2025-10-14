import 'package:cubit_shantika/data/api_service.dart';
import 'package:cubit_shantika/models/game_models.dart';

class GameRepository {
  final ApiService api;

  GameRepository(this.api);

  Future<List<GameModel>> fetchGames({int page = 1, int pageSize = 20}) async {
    final json = await api.getGames(page: page, pageSize: pageSize);
    final results = json['results'] as List<dynamic>;
    return results.map((e) => GameModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<GameModel>> searchGames({required String query, int page = 1, int pageSize = 20}) async {
    final json = await api.searchGames(query: query, page: page, pageSize: pageSize);
    final results = json['results'] as List<dynamic>;
    return results.map((e) => GameModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GameModel> getDetail(int id) async {
    final json = await api.getDetail(id);
    return GameModel.fromJson(json);
  }
}
