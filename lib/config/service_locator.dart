// lib/config/service_locator.dart
import 'dart:convert';

import 'package:cubit_shantika/data/db/favourite_db.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cubit_shantika/config/constant.dart';
import 'package:cubit_shantika/config/env/env.dart';
import 'package:cubit_shantika/data/api_service.dart';
import 'package:cubit_shantika/repository/game_repository.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
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

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['key'] = Env.apiKey;
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('REQUEST: ${options.method} ${options.uri.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('RESPONSE DATA:');
          try {
            final prettyJson = const JsonEncoder.withIndent('  ').convert(response.data);
            debugPrint(prettyJson);
          } catch (e) {
            // Kalau bukan JSON, print biasa
            debugPrint('${response.data}');
          }
          debugPrint('─────────────────────────────────────────────────');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('ERROR: ${error.message}');
          if (error.response?.data != null) {
            debugPrint('Error Data: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
    return dio;
  });

  getIt.registerFactory<ApiService>(
        () => ApiService(getIt<Dio>()),
  );

  getIt.registerSingleton<DatabaseHelper>(
    DatabaseHelper.instance,
  );

  getIt.registerSingleton<GameRepository>(
    GameRepository(getIt<ApiService>()),
  );
}