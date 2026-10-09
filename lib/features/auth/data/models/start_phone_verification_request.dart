import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_phone_verification_request.freezed.dart';
part 'start_phone_verification_request.g.dart';

@freezed
abstract class StartPhoneVerificationRequest
    with _$StartPhoneVerificationRequest {
  const factory StartPhoneVerificationRequest({
    required String verificationTicket,
  }) = _StartPhoneVerificationRequest;

  factory StartPhoneVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$StartPhoneVerificationRequestFromJson(json);
}
