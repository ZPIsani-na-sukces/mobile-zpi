import 'package:freezed_annotation/freezed_annotation.dart';

part 'accessibility_preferences.freezed.dart';
part 'accessibility_preferences.g.dart';

@freezed
abstract class AccessibilityPreferences with _$AccessibilityPreferences {
  const factory AccessibilityPreferences({
    required int fontScalePercent,
    required bool highContrastEnabled,
    required bool largeButtonsEnabled,
    required String seniorId,
    required DateTime updatedAt,
    required int version,
  }) = _AccessibilityPreferences;

  factory AccessibilityPreferences.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityPreferencesFromJson(json);
}
