// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Contact {

 String get contactId; String get seniorId; String get displayName; String get firstName; String get lastName; String? get relationshipLabel; String get phoneNumber; bool get isActive; ContactCreator get createdBy; DateTime get createdAt; DateTime get updatedAt; int get version;
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCopyWith<Contact> get copyWith => _$ContactCopyWithImpl<Contact>(this as Contact, _$identity);

  /// Serializes this Contact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Contact;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contact&&(identical(other.contactId, _this.contactId) || other.contactId == _this.contactId)&&(identical(other.seniorId, _this.seniorId) || other.seniorId == _this.seniorId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.relationshipLabel, _this.relationshipLabel) || other.relationshipLabel == _this.relationshipLabel)&&(identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.version, _this.version) || other.version == _this.version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Contact;
  return Object.hash(runtimeType,_this.contactId,_this.seniorId,_this.displayName,_this.firstName,_this.lastName,_this.relationshipLabel,_this.phoneNumber,_this.isActive,_this.createdBy,_this.createdAt,_this.updatedAt,_this.version);
}

@override
String toString() {
  final _this = this as Contact;
  return 'Contact(contactId: ${_this.contactId}, seniorId: ${_this.seniorId}, displayName: ${_this.displayName}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, relationshipLabel: ${_this.relationshipLabel}, phoneNumber: ${_this.phoneNumber}, isActive: ${_this.isActive}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $ContactCopyWith<$Res>  {
  factory $ContactCopyWith(Contact value, $Res Function(Contact) _then) = _$ContactCopyWithImpl;
@useResult
$Res call({
 String contactId, String seniorId, String displayName, String firstName, String lastName, String? relationshipLabel, String phoneNumber, bool isActive, ContactCreator createdBy, DateTime createdAt, DateTime updatedAt, int version
});


$ContactCreatorCopyWith<$Res> get createdBy;

}
/// @nodoc
class _$ContactCopyWithImpl<$Res>
    implements $ContactCopyWith<$Res> {
  _$ContactCopyWithImpl(this._self, this._then);

  final Contact _self;
  final $Res Function(Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contactId = null,Object? seniorId = null,Object? displayName = null,Object? firstName = null,Object? lastName = null,Object? relationshipLabel = freezed,Object? phoneNumber = null,Object? isActive = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(Contact(
contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,seniorId: null == seniorId ? _self.seniorId : seniorId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,relationshipLabel: freezed == relationshipLabel ? _self.relationshipLabel : relationshipLabel // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ContactCreator,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCreatorCopyWith<$Res> get createdBy {
  
  return $ContactCreatorCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Contact].
extension ContactPatterns on Contact {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contact value)  $default,){
final _that = this;
switch (_that) {
case _Contact():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contact value)?  $default,){
final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contactId,  String seniorId,  String displayName,  String firstName,  String lastName,  String? relationshipLabel,  String phoneNumber,  bool isActive,  ContactCreator createdBy,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.contactId,_that.seniorId,_that.displayName,_that.firstName,_that.lastName,_that.relationshipLabel,_that.phoneNumber,_that.isActive,_that.createdBy,_that.createdAt,_that.updatedAt,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contactId,  String seniorId,  String displayName,  String firstName,  String lastName,  String? relationshipLabel,  String phoneNumber,  bool isActive,  ContactCreator createdBy,  DateTime createdAt,  DateTime updatedAt,  int version)  $default,) {final _that = this;
switch (_that) {
case _Contact():
return $default(_that.contactId,_that.seniorId,_that.displayName,_that.firstName,_that.lastName,_that.relationshipLabel,_that.phoneNumber,_that.isActive,_that.createdBy,_that.createdAt,_that.updatedAt,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contactId,  String seniorId,  String displayName,  String firstName,  String lastName,  String? relationshipLabel,  String phoneNumber,  bool isActive,  ContactCreator createdBy,  DateTime createdAt,  DateTime updatedAt,  int version)?  $default,) {final _that = this;
switch (_that) {
case _Contact() when $default != null:
return $default(_that.contactId,_that.seniorId,_that.displayName,_that.firstName,_that.lastName,_that.relationshipLabel,_that.phoneNumber,_that.isActive,_that.createdBy,_that.createdAt,_that.updatedAt,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contact implements Contact {
  const _Contact({required this.contactId, required this.seniorId, required this.displayName, required this.firstName, required this.lastName, this.relationshipLabel, required this.phoneNumber, required this.isActive, required this.createdBy, required this.createdAt, required this.updatedAt, required this.version});
  factory _Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

@override final  String contactId;
@override final  String seniorId;
@override final  String displayName;
@override final  String firstName;
@override final  String lastName;
@override final  String? relationshipLabel;
@override final  String phoneNumber;
@override final  bool isActive;
@override final  ContactCreator createdBy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  int version;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCopyWith<_Contact> get copyWith => __$ContactCopyWithImpl<_Contact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contact&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.seniorId, seniorId) || other.seniorId == seniorId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.relationshipLabel, relationshipLabel) || other.relationshipLabel == relationshipLabel)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contactId,seniorId,displayName,firstName,lastName,relationshipLabel,phoneNumber,isActive,createdBy,createdAt,updatedAt,version);
}

@override
String toString() {
    return 'Contact(contactId: $contactId, seniorId: $seniorId, displayName: $displayName, firstName: $firstName, lastName: $lastName, relationshipLabel: $relationshipLabel, phoneNumber: $phoneNumber, isActive: $isActive, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ContactCopyWith<$Res> implements $ContactCopyWith<$Res> {
  factory _$ContactCopyWith(_Contact value, $Res Function(_Contact) _then) = __$ContactCopyWithImpl;
@override @useResult
$Res call({
 String contactId, String seniorId, String displayName, String firstName, String lastName, String? relationshipLabel, String phoneNumber, bool isActive, ContactCreator createdBy, DateTime createdAt, DateTime updatedAt, int version
});


@override $ContactCreatorCopyWith<$Res> get createdBy;

}
/// @nodoc
class __$ContactCopyWithImpl<$Res>
    implements _$ContactCopyWith<$Res> {
  __$ContactCopyWithImpl(this._self, this._then);

  final _Contact _self;
  final $Res Function(_Contact) _then;

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contactId = null,Object? seniorId = null,Object? displayName = null,Object? firstName = null,Object? lastName = null,Object? relationshipLabel = freezed,Object? phoneNumber = null,Object? isActive = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? version = null,}) {
  return _then(_Contact(
contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,seniorId: null == seniorId ? _self.seniorId : seniorId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,relationshipLabel: freezed == relationshipLabel ? _self.relationshipLabel : relationshipLabel // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as ContactCreator,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Contact
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactCreatorCopyWith<$Res> get createdBy {
  
  return $ContactCreatorCopyWith<$Res>(_self.createdBy, (value) {
    return _then(_self.copyWith(createdBy: value));
  });
}
}


/// @nodoc
mixin _$ContactCreator {

 String get userId; String get firstName; String get lastName; String get role;
/// Create a copy of ContactCreator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactCreatorCopyWith<ContactCreator> get copyWith => _$ContactCreatorCopyWithImpl<ContactCreator>(this as ContactCreator, _$identity);

  /// Serializes this ContactCreator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContactCreator;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactCreator&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContactCreator;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.lastName,_this.role);
}

@override
String toString() {
  final _this = this as ContactCreator;
  return 'ContactCreator(userId: ${_this.userId}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $ContactCreatorCopyWith<$Res>  {
  factory $ContactCreatorCopyWith(ContactCreator value, $Res Function(ContactCreator) _then) = _$ContactCreatorCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, String lastName, String role
});




}
/// @nodoc
class _$ContactCreatorCopyWithImpl<$Res>
    implements $ContactCreatorCopyWith<$Res> {
  _$ContactCreatorCopyWithImpl(this._self, this._then);

  final ContactCreator _self;
  final $Res Function(ContactCreator) _then;

/// Create a copy of ContactCreator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? lastName = null,Object? role = null,}) {
  return _then(ContactCreator(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactCreator].
extension ContactCreatorPatterns on ContactCreator {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactCreator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactCreator() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactCreator value)  $default,){
final _that = this;
switch (_that) {
case _ContactCreator():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactCreator value)?  $default,){
final _that = this;
switch (_that) {
case _ContactCreator() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  String lastName,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactCreator() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.role);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  String lastName,  String role)  $default,) {final _that = this;
switch (_that) {
case _ContactCreator():
return $default(_that.userId,_that.firstName,_that.lastName,_that.role);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  String lastName,  String role)?  $default,) {final _that = this;
switch (_that) {
case _ContactCreator() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactCreator implements ContactCreator {
  const _ContactCreator({required this.userId, required this.firstName, required this.lastName, required this.role});
  factory _ContactCreator.fromJson(Map<String, dynamic> json) => _$ContactCreatorFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  String lastName;
@override final  String role;

/// Create a copy of ContactCreator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactCreatorCopyWith<_ContactCreator> get copyWith => __$ContactCreatorCopyWithImpl<_ContactCreator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactCreatorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactCreator&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,lastName,role);
}

@override
String toString() {
    return 'ContactCreator(userId: $userId, firstName: $firstName, lastName: $lastName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$ContactCreatorCopyWith<$Res> implements $ContactCreatorCopyWith<$Res> {
  factory _$ContactCreatorCopyWith(_ContactCreator value, $Res Function(_ContactCreator) _then) = __$ContactCreatorCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, String lastName, String role
});




}
/// @nodoc
class __$ContactCreatorCopyWithImpl<$Res>
    implements _$ContactCreatorCopyWith<$Res> {
  __$ContactCreatorCopyWithImpl(this._self, this._then);

  final _ContactCreator _self;
  final $Res Function(_ContactCreator) _then;

/// Create a copy of ContactCreator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? lastName = null,Object? role = null,}) {
  return _then(_ContactCreator(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
