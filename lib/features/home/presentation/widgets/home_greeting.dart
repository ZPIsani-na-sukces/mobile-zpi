import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.firstName});

  final String firstName;

  static const _weekdays = [
    'poniedziałek',
    'wtorek',
    'środa',
    'czwartek',
    'piątek',
    'sobota',
    'niedziela',
  ];

  static const _months = [
    'stycznia',
    'lutego',
    'marca',
    'kwietnia',
    'maja',
    'czerwca',
    'lipca',
    'sierpnia',
    'września',
    'października',
    'listopada',
    'grudnia',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour >= 18 || now.hour < 5
        ? 'Dobry wieczór'
        : 'Dzień dobry';
    final date =
        '${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $firstName',
          style: AppTypography.headlineSmall.copyWith(
            color: context.colors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Dzisiaj jest $date',
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurface,
          ),
        ),
      ],
    );
  }
}
