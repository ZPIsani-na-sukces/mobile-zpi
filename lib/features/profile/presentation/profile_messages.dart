import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';

String saveErrorMessage(Object error) {
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 409 || code == 412 || code == 428) {
      return 'Dane zmieniły się w międzyczasie. Wróć i otwórz profil ponownie.';
    }
  }
  return 'Nie udało się zapisać. Spróbuj ponownie.';
}

String contactChangeErrorMessage(Object error, ContactChannel channel) =>
    switch (error) {
      AccountAlreadyExistsException() => switch (channel) {
        ContactChannel.phone =>
          'Ten numer jest już przypisany do innego konta.',
        ContactChannel.email =>
          'Ten adres e-mail jest już przypisany do innego konta.',
      },
      InvalidPhoneNumberException() =>
        'Na ten numer nie można wysłać SMS. Sprawdź numer.',
      InvalidCodeException() => switch (channel) {
        ContactChannel.phone =>
          'Nieprawidłowy kod. Sprawdź SMS i spróbuj ponownie '
              'albo wyślij nowy kod.',
        ContactChannel.email =>
          'Nieprawidłowy kod. Sprawdź e-mail i spróbuj ponownie '
              'albo wyślij nowy kod.',
      },
      TooManyAttemptsException() =>
        'Zbyt wiele prób. Odczekaj chwilę i spróbuj ponownie.',
      DioException(
        type: DioExceptionType.connectionError ||
            DioExceptionType.connectionTimeout ||
            DioExceptionType.receiveTimeout ||
            DioExceptionType.sendTimeout,
      ) =>
        'Brak połączenia z internetem. Spróbuj ponownie.',
      DioException(response: Response(statusCode: 503)) =>
        'Usługa jest chwilowo niedostępna. Spróbuj ponownie później.',
      DioException(response: Response(statusCode: 412 || 428)) =>
        'Dane zmieniły się w międzyczasie. Spróbuj ponownie.',
      _ => switch (channel) {
        ContactChannel.phone =>
          'Nie udało się zmienić numeru telefonu. Spróbuj ponownie.',
        ContactChannel.email =>
          'Nie udało się zmienić adresu e-mail. Spróbuj ponownie.',
      },
    };
