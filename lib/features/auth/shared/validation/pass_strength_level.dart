import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/auth/shared/validation/auth_validators.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

enum PassStrengthLevel {
  exposed,
  weak,
  medium,
  strong,
  secure;

  static final _characterClasses = [
    RegExp(r'[a-z]'),
    RegExp(r'[A-Z]'),
    RegExp(r'[0-9]'),
    RegExp(r'[^a-zA-Z0-9]'),
  ];

  static PassStrengthLevel? calculate(String password) {
    if (password.isEmpty) return null;
    if (commonDictionary[password] == true) return exposed;
    if (password.length < AuthValidators.passwordMinLength) return weak;

    final classCount = _characterClasses
        .where((characterClass) => characterClass.hasMatch(password))
        .length;

    return switch (classCount) {
      2 => medium,
      3 => strong,
      4 => secure,
      _ => weak,
    };
  }

  String get label => switch (this) {
    exposed => 'zbyt popularne',
    weak => 'słabe',
    medium => 'średnie',
    strong => 'silne',
    secure => 'bardzo silne',
  };

  IconData get icon => switch (this) {
    exposed || weak => Icons.error_outline,
    medium => Icons.info_outline,
    strong || secure => Icons.check_circle_outline,
  };

  Color color(AppColors colors) => switch (this) {
    exposed || weak => colors.error,
    medium => colors.warning,
    strong || secure => colors.success,
  };

  double get widthPerc => switch (this) {
    exposed => 0.1,
    weak => 0.25,
    medium => 0.5,
    strong => 0.75,
    secure => 1,
  };
}
