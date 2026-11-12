import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_zpi/features/med_history/data/models/medical_record.dart';
import 'package:mobile_zpi/features/med_history/presentation/med_history_labels.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_icon_circle.dart';

class MedFileCard extends StatelessWidget {
  const MedFileCard({
    super.key,
    required this.seniorId,
    required this.recordId,
    required this.file,
  });

  final String seniorId;
  final String recordId;
  final MedicalFile file;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: MergeSemantics(
        child: Semantics(
          button: true,
          hint: 'Otwórz podgląd',
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: AppRadius.lgAll,
              onTap: () => context.router.push(
                MedFilePreviewRoute(
                  seniorId: seniorId,
                  recordId: recordId,
                  file: file,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: SvgPicture.asset(
                        fileTypeIconAsset(file),
                        width: AppIconCircle.smallSize,
                        height: AppIconCircle.smallSize,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileDisplayName(file),
                            style: AppTypography.titleMedium.copyWith(
                              color: context.colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            fileTypeLabel(file),
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.colors.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ExcludeSemantics(
                      child: Icon(
                        Icons.chevron_right,
                        size: 28,
                        color: context.colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
