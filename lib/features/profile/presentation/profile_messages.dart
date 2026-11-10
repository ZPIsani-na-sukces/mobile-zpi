import 'package:dio/dio.dart';

String saveErrorMessage(Object error) {
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 409 || code == 412 || code == 428) {
      return 'Dane zmieniły się w międzyczasie. Wróć i otwórz profil ponownie.';
    }
  }
  return 'Nie udało się zapisać. Spróbuj ponownie.';
}
