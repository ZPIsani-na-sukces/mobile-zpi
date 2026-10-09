import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_reset_pass_code_request.freezed.dart';
part 'send_reset_pass_code_request.g.dart';

@freezed
abstract class SendResetPassCodeRequest with _$SendResetPassCodeRequest {
  const factory SendResetPassCodeRequest({
    required String identifier,
    @Default('sms') String channel,
  }) = _SendResetPassCodeRequest;

  factory SendResetPassCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendResetPassCodeRequestFromJson(json);
}
