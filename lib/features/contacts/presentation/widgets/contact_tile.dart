import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/contacts/presentation/widgets/call_button.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_initials_avatar.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.onTap,
    this.relationship,
  });

  final String name;
  final String phoneNumber;
  final VoidCallback onTap;
  final String? relationship;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final relationship = this.relationship;

    return Semantics(
      button: true,
      hint: 'Pokaż szczegóły',
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
            onTap: onTap,
            highlightColor: colors.surfacePressed,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  AppInitialsAvatar.small(name: name),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (relationship != null &&
                            relationship.isNotEmpty) ...[
                          Text(
                            relationship,
                            style: AppTypography.labelLarge.copyWith(
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Text(
                          name,
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  CallButton.compact(phoneNumber: phoneNumber, name: name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
