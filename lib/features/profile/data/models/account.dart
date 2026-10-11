import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String userId,
    required String role,
    required String firstName,
    required String lastName,
    String? email,
    required String phoneNumber,
    required bool phoneVerified,
    required bool emailVerified,
    required String status,
    required int version,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
