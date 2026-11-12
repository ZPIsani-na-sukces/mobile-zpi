import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/med_history/presentation/widgets/med_record_detail_row.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class MedRecordDetailsCard extends StatelessWidget {
  const MedRecordDetailsCard({super.key, required this.rows});

  final List<MedRecordDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: context.colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0)
                Divider(height: AppSpacing.xl, color: context.colors.outline),
              rows[i],
            ],
          ],
        ),
      ),
    );
  }
}
