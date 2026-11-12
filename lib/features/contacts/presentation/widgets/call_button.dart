import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/contacts/data/phone_call.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class CallButton extends StatelessWidget {
  const CallButton({super.key, required this.phoneNumber, required this.name})
    : compact = false;

  const CallButton.compact({
    super.key,
    required this.phoneNumber,
    required this.name,
  }) : compact = true;

  final String phoneNumber;
  final String name;
  final bool compact;

  static const double _compactSize = 52;
  static const double _height = 64;
  static const double _iconSize = 28;

  Future<void> _call(BuildContext context) async {
    try {
      await callPhone(phoneNumber);
    } on PhoneCallException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się otworzyć telefonu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = Icon(Icons.call, size: _iconSize, color: colors.onSuccess);

    return Semantics(
      button: true,
      label: 'Zadzwoń do $name',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: compact ? AppRadius.mdAll : AppRadius.lgAll,
          boxShadow: compact ? const [] : AppShadows.sm,
        ),
        child: Material(
          color: colors.success,
          borderRadius: compact ? AppRadius.mdAll : AppRadius.lgAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _call(context),
            highlightColor: colors.onSuccess.withValues(alpha: 0.16),
            child: compact
                ? SizedBox.square(dimension: _compactSize, child: icon)
                : SizedBox(
                    height: _height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppSpacing.sm,
                      children: [
                        icon,
                        Text(
                          'Zadzwoń',
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.onSuccess,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
