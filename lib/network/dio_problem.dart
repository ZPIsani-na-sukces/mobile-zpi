import 'package:dio/dio.dart';

extension DioProblem on DioException {
  String? get problemCode => switch (response?.data) {
    {'code': final String code} => code,
    _ => null,
  };

  Duration? get retryAfter =>
      switch (int.tryParse(response?.headers.value('retry-after') ?? '')) {
        final seconds? => Duration(seconds: seconds),
        null => null,
      };
}
