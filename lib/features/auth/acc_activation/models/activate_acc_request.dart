import 'package:freezed_annotation/freezed_annotation.dart';

part 'activate_acc_request.freezed.dart';
part 'activate_acc_request.g.dart';

@freezed
abstract class ActivateAccRequest with _$ActivateAccRequest {
  const factory ActivateAccRequest({
    required String challengeId,
    required String code,
  }) = _ActivateAccRequest;

  factory ActivateAccRequest.fromJson(Map<String, dynamic> json) =>
      _$ActivateAccRequestFromJson(json);
}
