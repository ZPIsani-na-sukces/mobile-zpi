import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_card.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';

class ContactValueStep extends StatelessWidget {
  const ContactValueStep({
    super.key,
    required this.channel,
    required this.controller,
    required this.isSending,
    required this.onChanged,
    required this.onSubmit,
    this.currentValue,
    this.errorText,
    this.error,
  });

  final ContactChannel channel;
  final TextEditingController controller;
  final bool isSending;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final String? currentValue;
  final String? errorText;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final isPhone = channel == ContactChannel.phone;
    final currentValue = this.currentValue;
    final error = this.error;

    return StepCard(
      title: isPhone ? 'Podaj nowy numer telefonu' : 'Podaj nowy adres e-mail',
      subtitle: isPhone
          ? 'Wyślemy na niego kod SMS, aby potwierdzić zmianę'
          : 'Wyślemy na niego kod, aby potwierdzić zmianę',
      children: [
        AppTextInput(
          label: isPhone ? 'Nowy numer telefonu' : 'Nowy adres e-mail',
          hintText: isPhone
              ? 'np. 600 123 456'
              : 'np. jan.kowalski@example.com',
          helperText: currentValue == null
              ? null
              : '${isPhone ? 'Obecny numer' : 'Obecny adres'}: $currentValue',
          controller: controller,
          leadingIcon: isPhone ? Icons.phone_outlined : Icons.mail_outline,
          autofocus: true,
          keyboardType: isPhone
              ? TextInputType.phone
              : TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: [
            isPhone ? AutofillHints.telephoneNumber : AutofillHints.email,
          ],
          errorText: errorText,
          onChanged: onChanged,
          onSubmitted: (_) {
            if (!isSending) onSubmit();
          },
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
        AppButton.primary(
          label: isSending ? 'Wysyłanie…' : 'Wyślij kod',
          onPressed: isSending ? null : onSubmit,
        ),
      ],
    );
  }
}
