import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String contactId,
    required String seniorId,
    required String displayName,
    String? firstName,
    String? lastName,
    String? relationshipLabel,
    required String phoneNumber,
    required bool isActive,
    ContactCreator? createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

@freezed
abstract class ContactCreator with _$ContactCreator {
  const factory ContactCreator({
    required String userId,
    required String firstName,
    required String lastName,
    required String role,
  }) = _ContactCreator;

  factory ContactCreator.fromJson(Map<String, dynamic> json) =>
      _$ContactCreatorFromJson(json);
}
