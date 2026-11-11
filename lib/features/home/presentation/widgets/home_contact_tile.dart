import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/home/data/models/home_overview.dart';
import 'package:mobile_zpi/features/home/data/phone_call.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_initials_avatar.dart';

class HomeContactTile extends StatelessWidget {
  const HomeContactTile({super.key, required this.contact});

  final HomeContact contact;

  static const double _callButtonSize = 52;
  static const double _callIconSize = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = contact.relationshipLabel;

    Future<void> call() async {
      try {
        await callPhone(contact.phoneNumber);
      } on PhoneCallException {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się otworzyć telefonu.')),
        );
      }
    }

    return Semantics(
      button: true,
      hint: 'Zadzwoń',
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.lgAll,
            side: colors.isHighContrast
                ? BorderSide(color: colors.outline, width: 2)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: call,
            highlightColor: colors.surfacePressed,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  AppInitialsAvatar.small(name: contact.displayName),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.displayName,
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ExcludeSemantics(
                    child: Container(
                      width: _callButtonSize,
                      height: _callButtonSize,
                      decoration: BoxDecoration(
                        color: colors.success,
                        borderRadius: AppRadius.mdAll,
                      ),
                      child: Icon(
                        Icons.call,
                        size: _callIconSize,
                        color: colors.onSuccess,
                      ),
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
