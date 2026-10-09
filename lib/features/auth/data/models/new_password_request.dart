import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_password_request.freezed.dart';
part 'new_password_request.g.dart';

@freezed
abstract class NewPasswordRequest with _$NewPasswordRequest {
  const factory NewPasswordRequest({
    required String challengeId,
    required String code,
    required String newPassword,
  }) = _NewPasswordRequest;

  factory NewPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$NewPasswordRequestFromJson(json);
}
