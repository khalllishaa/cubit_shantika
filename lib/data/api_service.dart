import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:cubit_shantika/config/constant.dart';
import 'package:cubit_shantika/models/game_models.dart';
import 'package:cubit_shantika/models/response/game_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: AppConfig.rawgBase)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/games")
  Future<HttpResponse<GamesResponse>> getGames({
    @Query("page") int? page,
    @Query("page_size") int? pageSize,
  });

  @GET("/games")
  Future<HttpResponse<GamesResponse>> searchGames({
    @Query("search") required String search,
    @Query("page") int? page,
    @Query("page_size") int? pageSize,
  });

  @GET("/games/{id}")
  Future<HttpResponse<GameModel>> getGameDetail({
    @Path("id") required int id,
  });
}