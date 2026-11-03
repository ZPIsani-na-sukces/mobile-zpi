import 'package:dio/dio.dart';
import 'package:mobile_zpi/config/app_env.dart';
import 'package:mobile_zpi/features/auth/shared/controllers/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

const _sentTokenKey = 'sentToken';
const _renewedKey = 'renewed';

Dio _createDio() {
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

  return dio;
}

@Riverpod(keepAlive: true)
Dio publicDio(Ref ref) {
  final dio = _createDio();

  ref.onDispose(dio.close);

  return dio;
}

@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final dio = _createDio();

  dio.interceptors.insert(
    0,
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authControllerProvider).value?.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          options.extra[_sentTokenKey] = token;
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final request = error.requestOptions;
        final sentToken = request.extra[_sentTokenKey];
        if (error.response?.statusCode != 401 ||
            sentToken is! String ||
            request.extra[_renewedKey] == true) {
          handler.next(error);
          return;
        }

        try {
          final session = await ref
              .read(authControllerProvider.notifier)
              .renewSession(sentToken);
          if (session == null) {
            handler.next(error);
            return;
          }
          request.extra[_renewedKey] = true;
          handler.resolve(await dio.fetch<dynamic>(request));
        } on DioException catch (failure) {
          handler.next(failure);
        } catch (_) {
          handler.next(error);
        }
      },
    ),
  );

  ref.onDispose(dio.close);

  return dio;
}

@Riverpod(keepAlive: true)
Dio routingDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://routing.openstreetmap.de/routed-foot',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {'User-Agent': 'mobile_zpi/1.0'},
    ),
  );

  if (AppEnv.isDev) dio.interceptors.add(LogInterceptor());

  ref.onDispose(dio.close);

  return dio;
}
