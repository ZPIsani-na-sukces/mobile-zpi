import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_reset_pass_code_request.freezed.dart';
part 'verify_reset_pass_code_request.g.dart';

@freezed
abstract class VerifyResetPassCodeRequest with _$VerifyResetPassCodeRequest {
  const factory VerifyResetPassCodeRequest({
    required String challengeId,
    required String code,
  }) = _VerifyResetPassCodeRequest;

  factory VerifyResetPassCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetPassCodeRequestFromJson(json);
}
