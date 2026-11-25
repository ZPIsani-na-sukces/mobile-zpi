import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/resend_code_button.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_card.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';

class ContactCodeStep extends StatelessWidget {
  const ContactCodeStep({
    super.key,
    required this.channel,
    required this.destination,
    required this.smsCodeController,
    required this.emailCodeController,
    required this.resendAfter,
    required this.isSending,
    required this.isConfirming,
    required this.onCodeChanged,
    required this.onConfirm,
    required this.onResend,
    required this.onBack,
    this.codeError,
    this.error,
  });

  final ContactChannel channel;
  final String destination;
  final VerificationCodeController smsCodeController;
  final TextEditingController emailCodeController;
  final DateTime? resendAfter;
  final bool isSending;
  final bool isConfirming;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onConfirm;
  final VoidCallback onResend;
  final VoidCallback onBack;
  final String? codeError;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isPhone = channel == ContactChannel.phone;
    final error = this.error;

    void confirm() {
      if (!isSending && !isConfirming) onConfirm();
    }

    return StepCard(
      title: isPhone ? 'Wpisz kod z SMS' : 'Wpisz kod z e-maila',
      subtitle:
          '${isPhone ? 'Wysłaliśmy go na numer' : 'Wysłaliśmy go na adres'} '
          '$destination',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            if (isPhone)
              AppCodeInput(
                label: 'Kod z SMS',
                controller: smsCodeController,
                autoFocus: true,
                errorText: codeError,
                onChanged: onCodeChanged,
                onCompleted: (_) => confirm(),
              )
            else
              AppTextInput(
                label: 'Kod z e-maila',
                hintText: 'Wklej kod z wiadomości',
                controller: emailCodeController,
                leadingIcon: Icons.key_outlined,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                errorText: codeError,
                onChanged: onCodeChanged,
                onSubmitted: (_) => confirm(),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Kod nie dotarł?', style: AppTypography.bodyMedium),
                ResendCodeButton(
                  resendAfter: resendAfter,
                  isLoading: isSending,
                  onPressed: () {
                    if (!isConfirming) onResend();
                  },
                ),
              ],
            ),
          ],
        ),
        if (error != null)
          Text(
            error,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: context.colors.error,
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            AppButton.primary(
              label: isConfirming ? 'Potwierdzanie…' : 'Potwierdź',
              onPressed: isSending || isConfirming ? null : onConfirm,
            ),
            AppButton.secondary(
              label: 'Wstecz',
              onPressed: isConfirming ? null : onBack,
            ),
          ],
        ),
      ],
    );
  }
}
