import 'package:cubit_shantika/config/constant.dart';
import 'package:dio/dio.dart';

import '../config/env/env.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? dio})
      : dio = dio ??
      Dio(BaseOptions(
        baseUrl: AppConfig.rawgBase,
        queryParameters: {'key': Env.apiKey},
        connectTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 15),
      ));

  Future<Map<String, dynamic>> getGames({int page = 1, int pageSize = AppConfig.defaultPageSize}) async {
    final response = await dio.get('/games', queryParameters: {'page': page, 'page_size': pageSize});
    return (response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> searchGames({required String query, int page = 1, int pageSize = AppConfig.defaultPageSize}) async {
    final response = await dio.get('/games', queryParameters: {'search': query, 'page': page, 'page_size': pageSize});
    return (response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getDetail(int id) async {
    final response = await dio.get('/games/$id');
    return (response.data as Map<String, dynamic>);
  }
}
