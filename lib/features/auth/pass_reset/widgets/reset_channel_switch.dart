import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/reset_channel.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class ResetChannelSwitch extends StatelessWidget {
  const ResetChannelSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ResetChannel value;
  final ValueChanged<ResetChannel> onChanged;

  static const double _height = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SegmentedButton<ResetChannel>(
      segments: const [
        ButtonSegment(
          value: ResetChannel.sms,
          label: Text('SMS'),
          icon: Icon(Icons.phone_outlined),
        ),
        ButtonSegment(
          value: ResetChannel.email,
          label: Text('E-mail'),
          icon: Icon(Icons.mail_outline),
        ),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
      style: SegmentedButton.styleFrom(
        minimumSize: const Size(0, _height),
        textStyle: AppTypography.labelLarge,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        selectedBackgroundColor: colors.primary,
        selectedForegroundColor: colors.onPrimary,
        side: BorderSide(color: colors.inputBorder),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
    );
  }
}
