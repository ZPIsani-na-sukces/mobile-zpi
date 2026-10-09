import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_code_request.freezed.dart';
part 'reset_code_request.g.dart';

@freezed
abstract class ResetCodeRequest with _$ResetCodeRequest {
  const factory ResetCodeRequest({
    required String identifier,
    @Default('sms') String channel,
  }) = _ResetCodeRequest;

  factory ResetCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetCodeRequestFromJson(json);
}
