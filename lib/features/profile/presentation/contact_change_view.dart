import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/auth/shared/validation/auth_validators.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_progress.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/models/contact_channel.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:mobile_zpi/features/profile/presentation/profile_messages.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/contact_code_step.dart';
import 'package:mobile_zpi/features/profile/presentation/widgets/contact_value_step.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

const _stepCount = 2;
const _pageTransitionDuration = Duration(milliseconds: 300);

@RoutePage()
class ContactChangeView extends HookConsumerWidget {
  const ContactChangeView({
    super.key,
    required this.channel,
    this.currentValue,
  });

  final ContactChannel channel;
  final String? currentValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentStep = useState(0);

    final valueController = useTextEditingController();
    final smsCodeController = useVerificationCodeController();
    final emailCodeController = useTextEditingController();

    final valueError = useState<String?>(null);
    final codeError = useState<String?>(null);
    final error = useState<String?>(null);
    final sending = useState(false);
    final confirming = useState(false);

    final requested = useState<String?>(null);
    final challenge = useState<PhoneChallenge?>(null);
    final resendAfter = useState<DateTime?>(null);

    final isPhone = channel == ContactChannel.phone;

    void goToStep(int step) {
      FocusScope.of(context).unfocus();
      error.value = null;
      pageController.animateToPage(
        step,
        duration: _pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }

    String normalize(String value) => switch (channel) {
      ContactChannel.phone =>
        AuthValidators.normalizePhoneNumber(value) ?? value.trim(),
      ContactChannel.email => value.trim(),
    };

    String? validate(String value) {
      final formatError = switch (channel) {
        ContactChannel.phone => AuthValidators.phoneNumber(value),
        ContactChannel.email => AuthValidators.requiredEmail(value),
      };
      if (formatError != null) return formatError;

      final current = currentValue;
      final isCurrent =
          current != null &&
          normalize(current).toLowerCase() == normalize(value).toLowerCase();
      if (!isCurrent) return null;
      return switch (channel) {
        ContactChannel.phone => 'To jest Twój obecny numer telefonu',
        ContactChannel.email => 'To jest Twój obecny adres e-mail',
      };
    }

    Future<void> requestCode(String value) async {
      sending.value = true;
      error.value = null;
      try {
        final newChallenge = await ref
            .read(profileRepositoryProvider)
            .startContactChange(channel, value);
        if (!context.mounted) return;
        requested.value = value;
        challenge.value = newChallenge;
        resendAfter.value = newChallenge.resendAfter;
        smsCodeController.clear();
        emailCodeController.clear();
        codeError.value = null;
        goToStep(1);
      } catch (e) {
        if (!context.mounted) return;
        switch (e) {
          case AccountAlreadyExistsException() || InvalidPhoneNumberException():
            valueError.value = contactChangeErrorMessage(e, channel);
            goToStep(0);
          case TooManyAttemptsException(:final retryAfter?):
            resendAfter.value = DateTime.now().add(retryAfter);
            error.value = contactChangeErrorMessage(e, channel);
          default:
            error.value = contactChangeErrorMessage(e, channel);
        }
      } finally {
        if (context.mounted) sending.value = false;
      }
    }

    void onSendCode() {
      if (sending.value) return;
      valueError.value = validate(valueController.text);
      if (valueError.value != null) return;

      final value = normalize(valueController.text);
      FocusScope.of(context).unfocus();
      if (challenge.value != null && value == requested.value) {
        goToStep(1);
        return;
      }
      requestCode(value);
    }

    void onResendCode() {
      final value = requested.value;
      if (value != null && !sending.value) requestCode(value);
    }

    Future<void> onConfirm() async {
      final current = challenge.value;
      if (current == null || sending.value || confirming.value) return;

      final code = isPhone
          ? smsCodeController.text
          : emailCodeController.text.trim();
      codeError.value = isPhone
          ? AuthValidators.verificationCode(code)
          : AuthValidators.emailCode(code);
      if (codeError.value != null) return;

      FocusScope.of(context).unfocus();
      confirming.value = true;
      error.value = null;
      try {
        await ref
            .read(profileControllerProvider.notifier)
            .confirmContactChange(
              channel: channel,
              challengeId: current.challengeId,
              code: code,
            );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(switch (channel) {
              ContactChannel.phone =>
                'Numer telefonu został zmieniony. '
                    'Przy logowaniu używaj teraz numeru ${requested.value}.',
              ContactChannel.email => 'Adres e-mail został zmieniony.',
            }),
            duration: const Duration(seconds: 5),
          ),
        );
        context.router.pop();
      } catch (e) {
        if (!context.mounted) return;
        switch (e) {
          case InvalidCodeException():
            codeError.value = contactChangeErrorMessage(e, channel);
          case AccountAlreadyExistsException():
            challenge.value = null;
            requested.value = null;
            valueError.value = contactChangeErrorMessage(e, channel);
            goToStep(0);
          default:
            error.value = contactChangeErrorMessage(e, channel);
        }
      } finally {
        if (context.mounted) confirming.value = false;
      }
    }

    return PopScope(
      canPop: currentStep.value == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !confirming.value) goToStep(0);
      },
      child: BackScaffold(
        title: isPhone ? 'Zmiana telefonu' : 'Zmiana e-maila',
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  0,
                ),
                child: StepProgress(
                  currentStep: currentStep.value,
                  stepCount: _stepCount,
                  duration: _pageTransitionDuration,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => currentStep.value = page,
                  children: [
                    ContactValueStep(
                      channel: channel,
                      controller: valueController,
                      currentValue: currentValue,
                      isSending: sending.value,
                      errorText: valueError.value,
                      error: currentStep.value == 0 ? error.value : null,
                      onChanged: (_) {
                        valueError.value = null;
                        error.value = null;
                      },
                      onSubmit: onSendCode,
                    ),
                    ContactCodeStep(
                      channel: channel,
                      destination: requested.value ?? '',
                      smsCodeController: smsCodeController,
                      emailCodeController: emailCodeController,
                      resendAfter: resendAfter.value,
                      isSending: sending.value,
                      isConfirming: confirming.value,
                      codeError: codeError.value,
                      error: currentStep.value == 1 ? error.value : null,
                      onCodeChanged: (_) {
                        codeError.value = null;
                        error.value = null;
                      },
                      onConfirm: onConfirm,
                      onResend: onResendCode,
                      onBack: () => goToStep(0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
