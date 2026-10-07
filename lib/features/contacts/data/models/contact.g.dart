// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  contactId: json['contactId'] as String,
  seniorId: json['seniorId'] as String,
  displayName: json['displayName'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  relationshipLabel: json['relationshipLabel'] as String?,
  phoneNumber: json['phoneNumber'] as String,
  isActive: json['isActive'] as bool,
  createdBy: ContactCreator.fromJson(json['createdBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['version'] as num).toInt(),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'contactId': instance.contactId,
  'seniorId': instance.seniorId,
  'displayName': instance.displayName,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'relationshipLabel': instance.relationshipLabel,
  'phoneNumber': instance.phoneNumber,
  'isActive': instance.isActive,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'version': instance.version,
};

_ContactCreator _$ContactCreatorFromJson(Map<String, dynamic> json) =>
    _ContactCreator(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$ContactCreatorToJson(_ContactCreator instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
    };
