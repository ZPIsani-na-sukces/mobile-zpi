import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_new_pass_request.freezed.dart';
part 'set_new_pass_request.g.dart';

@freezed
abstract class SetNewPassRequest with _$SetNewPassRequest {
  const factory SetNewPassRequest({
    required String challengeId,
    required String code,
    required String newPassword,
  }) = _SetNewPassRequest;

  factory SetNewPassRequest.fromJson(Map<String, dynamic> json) =>
      _$SetNewPassRequestFromJson(json);
}
