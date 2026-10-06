import 'package:dio/dio.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  if (AppEnv.isDev) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  ref.onDispose(dio.close);

  return dio;
}
