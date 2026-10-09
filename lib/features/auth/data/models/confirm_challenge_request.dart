import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_challenge_request.freezed.dart';
part 'confirm_challenge_request.g.dart';

@freezed
abstract class ConfirmChallengeRequest with _$ConfirmChallengeRequest {
  const factory ConfirmChallengeRequest({
    required String challengeId,
    required String code,
  }) = _ConfirmChallengeRequest;

  factory ConfirmChallengeRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmChallengeRequestFromJson(json);
}
