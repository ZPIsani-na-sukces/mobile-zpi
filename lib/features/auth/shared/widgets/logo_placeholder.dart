import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';

class LogoPlaceholder extends StatelessWidget {
  const LogoPlaceholder({super.key});

  static const double _size = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadius.xlAll,
      ),
      child: Icon(
        Icons.home_rounded,
        size: _size / 2,
        color: context.colors.onPrimary,
      ),
    );
  }
}
