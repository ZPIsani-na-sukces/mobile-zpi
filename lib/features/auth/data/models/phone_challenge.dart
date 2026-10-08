import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_challenge.freezed.dart';
part 'phone_challenge.g.dart';

@freezed
abstract class PhoneChallenge with _$PhoneChallenge {
  const factory PhoneChallenge({
    required String challengeId,
    required DateTime resendAfter,
  }) = _PhoneChallenge;

  factory PhoneChallenge.fromJson(Map<String, dynamic> json) =>
      _$PhoneChallengeFromJson(json);
}
