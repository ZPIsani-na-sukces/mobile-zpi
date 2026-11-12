import 'package:flutter/material.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_card.dart';
import 'package:mobile_zpi/widgets/app_detail_row.dart';

class AppDetailsCard extends StatelessWidget {
  const AppDetailsCard({super.key, required this.rows});

  final List<AppDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
    );
  }
}
