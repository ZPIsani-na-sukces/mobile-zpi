import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_acc_activation_code_request.freezed.dart';
part 'send_acc_activation_code_request.g.dart';

@freezed
abstract class SendAccActivationCodeRequest
    with _$SendAccActivationCodeRequest {
  const factory SendAccActivationCodeRequest({
    required String verificationTicket,
  }) = _SendAccActivationCodeRequest;

  factory SendAccActivationCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendAccActivationCodeRequestFromJson(json);
}
