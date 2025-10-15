import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:cubit_shantika/config/constant.dart';
import 'package:cubit_shantika/config/env/env.dart';
import 'package:cubit_shantika/data/api_service.dart';
import 'package:cubit_shantika/repository/game_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==================== DIO ====================
  getIt.registerFactory<Dio>(() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: AppConfig.rawgBase,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Interceptor untuk auto tambah API Key
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['key'] = Env.apiKey;
          return handler.next(options);
        },
      ),
    );

    return dio;
  });

  // ==================== API SERVICE ====================
  getIt.registerFactory<ApiService>(
        () => ApiService(getIt<Dio>()),
  );

  // // ==================== DATABASE ====================
  // getIt.registerSingleton<DatabaseHelper>(
  //   DatabaseHelper.instance,
  // );
  //
  // // ==================== REPOSITORY ====================
  getIt.registerSingleton<GameRepository>(
    GameRepository(getIt<ApiService>()),
  );
  //
  // getIt.registerSingleton<FavouriteRepository>(
  //   FavouriteRepository(getIt<DatabaseHelper>()),
  // );
}