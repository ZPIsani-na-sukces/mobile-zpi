import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/sos/data/sos_alarm.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/features/sos/presentation/widgets/sos_detail_row.dart';
import 'package:mobile_zpi/keys.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';

class SosDetailsCard extends StatelessWidget {
  const SosDetailsCard({
    super.key,
    required this.alarm,
    required this.position,
  });

  final SosAlarm? alarm;
  final SosFix? position;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accuracy = position?.accuracyMeters?.round();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: colors.cardBorder,
        borderRadius: AppRadius.lgAll,
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            if (alarm case final alarm?)
              SosDetailRow(
                icon: Icons.schedule,
                iconColor: colors.primary,
                title: alarm.statusLabel,
                titleEmphasis: alarm.statusTime,
              ),
            if (position == null)
              SosDetailRow(
                key: keys.sos.locationMissingRow,
                icon: Icons.location_off_outlined,
                iconColor: colors.onSurface,
                title: 'Bez lokalizacji',
                subtitle: 'Nie udało się ustalić, gdzie jesteś.',
              )
            else
              SosDetailRow(
                key: keys.sos.locationSentRow,
                icon: Icons.location_on_outlined,
                iconColor: colors.primary,
                title: 'Lokalizacja wysłana',
                subtitle: accuracy == null
                    ? null
                    : 'Dokładność około $accuracy m.',
              ),
            SosDetailRow(
              icon: Icons.phone_in_talk_outlined,
              iconColor: colors.primary,
              title: 'Miej telefon przy sobie',
              subtitle: 'Opiekun może zadzwonić.',
            ),
          ],
        ),
      ),
    );
  }
}
