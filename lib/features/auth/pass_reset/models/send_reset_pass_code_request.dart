import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/reset_channel.dart';

part 'send_reset_pass_code_request.freezed.dart';
part 'send_reset_pass_code_request.g.dart';

@freezed
abstract class SendResetPassCodeRequest with _$SendResetPassCodeRequest {
  const factory SendResetPassCodeRequest({
    required ResetChannel channel,
    required String identifier,
  }) = _SendResetPassCodeRequest;

  factory SendResetPassCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendResetPassCodeRequestFromJson(json);
}
