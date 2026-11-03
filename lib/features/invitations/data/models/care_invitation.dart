import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_zpi/features/contacts/data/models/contact.dart';

part 'care_invitation.freezed.dart';
part 'care_invitation.g.dart';

@freezed
abstract class CareInvitation with _$CareInvitation {
  const factory CareInvitation({
    required String code,
    required String status,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _CareInvitation;

  factory CareInvitation.fromJson(Map<String, dynamic> json) =>
      _$CareInvitationFromJson(json);
}

@freezed
abstract class InvitationSender with _$InvitationSender {
  const factory InvitationSender({
    required String firstName,
    required String role,
  }) = _InvitationSender;

  factory InvitationSender.fromJson(Map<String, dynamic> json) =>
      _$InvitationSenderFromJson(json);
}

@freezed
abstract class InvitationPreview with _$InvitationPreview {
  const factory InvitationPreview({
    required InvitationSender sender,
    required String status,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _InvitationPreview;

  factory InvitationPreview.fromJson(Map<String, dynamic> json) =>
      _$InvitationPreviewFromJson(json);
}

@freezed
abstract class CareRelationship with _$CareRelationship {
  const factory CareRelationship({
    required String relationshipId,
    required ContactCreator caretaker,
    required String status,
    required DateTime createdAt,
  }) = _CareRelationship;

  factory CareRelationship.fromJson(Map<String, dynamic> json) =>
      _$CareRelationshipFromJson(json);
}
