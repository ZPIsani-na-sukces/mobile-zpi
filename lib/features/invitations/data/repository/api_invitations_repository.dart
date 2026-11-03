import 'package:dio/dio.dart';
import 'package:mobile_zpi/features/invitations/data/invitation_exceptions.dart';
import 'package:mobile_zpi/features/invitations/data/models/care_invitation.dart';
import 'package:mobile_zpi/features/invitations/data/repository/invitations_repository.dart';

class ApiInvitationsRepository implements InvitationsRepository {
  ApiInvitationsRepository(this._dio);

  final Dio _dio;

  @override
  Future<CareInvitation> createInvitation() async {
    final response = await _dio.post<Map<String, dynamic>>('/care-invitations');
    return CareInvitation.fromJson(response.data!);
  }

  @override
  Future<InvitationPreview> preview(String code) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/care-invitations/$code',
      );
      final preview = InvitationPreview.fromJson(response.data!);
      // The API still shows an invitation to the person who accepted it.
      if (preview.status != 'pending') {
        throw const InvitationCodeException(InvitationCodeError.used);
      }
      return preview;
    } on DioException catch (e) {
      throw _codeException(e);
    }
  }

  @override
  Future<void> accept(String code) async {
    try {
      await _dio.post<void>('/care-invitations/accept', data: {'code': code});
    } on DioException catch (e) {
      throw _codeException(e);
    }
  }

  @override
  Future<List<CareRelationship>> caretakers(String seniorId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/seniors/$seniorId/caretakers',
      queryParameters: {'limit': 100},
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => CareRelationship.fromJson(item as Map<String, dynamic>))
        .where((relationship) => relationship.status == 'active')
        .toList();
  }

  @override
  Future<void> removeCaretaker(String relationshipId) async {
    await _dio.delete<void>('/care-relationships/$relationshipId');
  }

  Exception _codeException(DioException e) {
    final error = switch (e.response) {
      Response(statusCode: 400 || 404) => InvitationCodeError.invalid,
      Response(statusCode: 403) => InvitationCodeError.notForYou,
      Response(statusCode: 409, data: {'code': 'relationshipAlreadyExists'}) =>
        InvitationCodeError.alreadyLinked,
      Response(statusCode: 409) => InvitationCodeError.used,
      Response(statusCode: 429) => InvitationCodeError.tooManyAttempts,
      _ => null,
    };
    return error == null ? e : InvitationCodeException(error);
  }
}
