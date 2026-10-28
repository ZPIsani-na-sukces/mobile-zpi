import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/pass_reset/controllers/send_reset_pass_code_controller.dart';
import 'package:mobile_zpi/features/auth/pass_reset/controllers/set_new_pass_controller.dart';
import 'package:mobile_zpi/features/auth/pass_reset/controllers/verify_reset_pass_code_controller.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/set_new_pass_request.dart';
import 'package:mobile_zpi/features/auth/pass_reset/models/verify_reset_pass_code_request.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/auth/shared/validation/auth_validators.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/pass_strength.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/resend_code_button.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_card.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_progress.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';

const _stepCount = 3;
const _pageTransitionDuration = Duration(milliseconds: 300);

@RoutePage()
class ResetPassView extends HookConsumerWidget {
  const ResetPassView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentStep = useState(0);

    final phoneController = useTextEditingController();
    final codeController = useVerificationCodeController();
    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final passwordHidden = useState(true);
    final repeatPasswordHidden = useState(true);

    final phoneError = useState<String?>(null);
    final codeError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final repeatPasswordError = useState<String?>(null);

    final requestedPhone = useState<String?>(null);
    final challenge = useState<PhoneChallenge?>(null);
    final verifiedCode = useState<String?>(null);

    final requestState = ref.watch(sendResetPassCodeControllerProvider);
    final verifyState = ref.watch(verifyResetPassCodeControllerProvider);
    final resetState = ref.watch(setNewPassControllerProvider);
    final isRequesting = requestState.isLoading;
    final isVerifying = verifyState.isLoading;
    final isResetting = resetState.isLoading;

    void goToStep(int step) {
      FocusScope.of(context).unfocus();
      pageController.animateToPage(
        step,
        duration: _pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }

    void clearControllerErrors() {
      ref.read(sendResetPassCodeControllerProvider.notifier).clearError();
      ref.read(verifyResetPassCodeControllerProvider.notifier).clearError();
      ref.read(setNewPassControllerProvider.notifier).clearError();
    }

    ref.listen(sendResetPassCodeControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      if (next case AsyncData(value: final newChallenge?)) {
        challenge.value = newChallenge;
        verifiedCode.value = null;
        codeController.clear();
        codeError.value = null;
        goToStep(1);
      }
    });

    ref.listen(verifyResetPassCodeControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      switch (next) {
        case AsyncData():
          verifiedCode.value = codeController.text;
          goToStep(2);
        case AsyncError(:final error) when _isCodeError(error):
          codeError.value = _resetPasswordErrorMessage(error);
        default:
      }
    });

    ref.listen(setNewPassControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      switch (next) {
        case AsyncData():
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Hasło zostało zmienione. Zaloguj się nowym hasłem.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
          context.router.replaceAll([const LoginRoute()]);
        case AsyncError(:final error) when _isCodeError(error):
          verifiedCode.value = null;
          codeError.value = _resetPasswordErrorMessage(error);
          goToStep(1);
        default:
      }
    });

    void requestCode(String phone) {
      clearControllerErrors();
      requestedPhone.value = phone;
      ref.read(sendResetPassCodeControllerProvider.notifier).send(phone);
    }

    void onSendCode() {
      phoneError.value = AuthValidators.phoneNumber(phoneController.text);
      if (phoneError.value != null) return;

      FocusScope.of(context).unfocus();
      final phone = AuthValidators.normalizePhoneNumber(phoneController.text)!;
      if (challenge.value != null && phone == requestedPhone.value) {
        goToStep(1);
        return;
      }
      requestCode(phone);
    }

    void onResendCode() => requestCode(requestedPhone.value!);

    ValueChanged<String> clearErrors(ValueNotifier<String?> fieldError) => (_) {
      fieldError.value = null;
      clearControllerErrors();
    };

    void onBack() {
      clearControllerErrors();
      goToStep(currentStep.value - 1);
    }

    void onConfirmCode() {
      codeError.value = AuthValidators.verificationCode(codeController.text);
      if (codeError.value != null) return;

      if (codeController.text == verifiedCode.value) {
        goToStep(2);
        return;
      }

      FocusScope.of(context).unfocus();
      clearControllerErrors();
      ref
          .read(verifyResetPassCodeControllerProvider.notifier)
          .verify(
            VerifyResetPassCodeRequest(
              challengeId: challenge.value!.challengeId,
              code: codeController.text,
            ),
          );
    }

    void onResetPassword() {
      final password = passwordController.text;
      passwordError.value = AuthValidators.password(password);
      repeatPasswordError.value = AuthValidators.repeatPassword(
        repeatPasswordController.text,
        password,
      );

      if (passwordError.value != null || repeatPasswordError.value != null) {
        return;
      }

      FocusScope.of(context).unfocus();

      ref
          .read(setNewPassControllerProvider.notifier)
          .submit(
            SetNewPassRequest(
              challengeId: challenge.value!.challengeId,
              code: codeController.text,
              newPassword: password,
            ),
          );
    }

    void onSignIn() => context.router.maybePop();

    final codeStepError = switch ((requestState.error, verifyState.error)) {
      (final error?, _) => error,
      (_, final error?) when !_isCodeError(error) => error,
      _ => null,
    };

    final passwordStepError = switch (resetState.error) {
      final error? when !_isCodeError(error) => error,
      _ => null,
    };

    return PopScope(
      canPop: currentStep.value == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isVerifying && !isResetting) onBack();
      },
      child: Scaffold(
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
                  // change page only using button, swipping disabled
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => currentStep.value = page,
                  children: [
                    StepCard(
                      title: 'Nie pamiętasz hasła?',
                      subtitle: 'Podaj numer telefonu, a wyślemy Ci kod SMS',
                      children: [
                        AppTextInput(
                          label: 'Numer telefonu',
                          hintText: 'np. 600 123 456',
                          controller: phoneController,
                          leadingIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          errorText: phoneError.value,
                          onChanged: clearErrors(phoneError),
                          onSubmitted: (_) => onSendCode(),
                        ),
                        if (currentStep.value == 0 &&
                            requestState.error != null)
                          Text(
                            _resetPasswordErrorMessage(requestState.error!),
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.colors.error,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppButton.primary(
                              label: isRequesting ? 'Wysyłanie…' : 'Wyślij kod',
                              onPressed: isRequesting ? null : onSendCode,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Pamiętasz hasło?',
                                  style: AppTypography.bodyMedium,
                                ),
                                AppButton.text(
                                  label: 'Zaloguj się',
                                  onPressed: onSignIn,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    StepCard(
                      title: 'Wpisz kod z SMS',
                      subtitle:
                          'Wysłaliśmy go na numer '
                          '${requestedPhone.value ?? ''}',
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppCodeInput(
                              label: 'Kod z SMS',
                              controller: codeController,
                              autoFocus: true,
                              errorText: codeError.value,
                              onChanged: (value) {
                                verifiedCode.value = null;
                                clearErrors(codeError)(value);
                              },
                              onCompleted: (_) {
                                if (!isVerifying) onConfirmCode();
                              },
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Kod nie dotarł?',
                                  style: AppTypography.bodyMedium,
                                ),
                                ResendCodeButton(
                                  resendAfter: challenge.value?.resendAfter,
                                  isLoading: isRequesting,
                                  onPressed: () {
                                    if (!isVerifying) onResendCode();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (currentStep.value == 1 && codeStepError != null)
                          Text(
                            _resetPasswordErrorMessage(codeStepError),
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
                              label: isVerifying ? 'Sprawdzanie…' : 'Dalej',
                              onPressed: isRequesting || isVerifying
                                  ? null
                                  : onConfirmCode,
                            ),
                            AppButton.secondary(
                              label: 'Wstecz',
                              onPressed: isVerifying ? null : onBack,
                            ),
                          ],
                        ),
                      ],
                    ),
                    StepCard(
                      title: 'Ustaw nowe hasło',
                      subtitle: 'Wymyśl nowe hasło do swojego konta',
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextInput(
                              label: 'Nowe hasło',
                              hintText: 'Wpisz nowe hasło',
                              helperText:
                                  'Co najmniej ${AuthValidators.passwordMinLength} znaków',
                              controller: passwordController,
                              leadingIcon: Icons.lock_outline,
                              obscureText: passwordHidden.value,
                              trailingIcon: passwordHidden.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              trailingIconTooltip: passwordHidden.value
                                  ? 'Pokaż hasło'
                                  : 'Ukryj hasło',
                              onTrailingIconPressed: () =>
                                  passwordHidden.value = !passwordHidden.value,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              errorText: passwordError.value,
                              onChanged: clearErrors(passwordError),
                            ),
                            PassStrength(controller: passwordController),
                          ],
                        ),
                        AppTextInput(
                          label: 'Powtórz nowe hasło',
                          hintText: 'Wpisz nowe hasło ponownie',
                          controller: repeatPasswordController,
                          leadingIcon: Icons.lock_outline,
                          obscureText: repeatPasswordHidden.value,
                          trailingIcon: repeatPasswordHidden.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          trailingIconTooltip: repeatPasswordHidden.value
                              ? 'Pokaż hasło'
                              : 'Ukryj hasło',
                          onTrailingIconPressed: () =>
                              repeatPasswordHidden.value =
                                  !repeatPasswordHidden.value,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          errorText: repeatPasswordError.value,
                          onChanged: clearErrors(repeatPasswordError),
                          onSubmitted: (_) => onResetPassword(),
                        ),
                        if (currentStep.value == 2 && passwordStepError != null)
                          Text(
                            _resetPasswordErrorMessage(passwordStepError),
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
                              label: isResetting
                                  ? 'Zapisywanie…'
                                  : 'Zmień hasło',
                              onPressed: isResetting ? null : onResetPassword,
                            ),
                            AppButton.secondary(
                              label: 'Wstecz',
                              onPressed: isResetting ? null : onBack,
                            ),
                          ],
                        ),
                      ],
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

bool _isCodeError(Object error) =>
    error is InvalidCodeException || error is CodeExpiredException;

String _resetPasswordErrorMessage(Object error) => switch (error) {
  InvalidCodeException() =>
    'Nieprawidłowy kod. Sprawdź SMS i spróbuj ponownie.',
  CodeExpiredException() => 'Kod wygasł. Wyślij nowy kod.',
  TooManyAttemptsException() =>
    'Zbyt wiele prób. Odczekaj chwilę i spróbuj ponownie.',
  DioException(
    type: DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout,
  ) =>
    'Brak połączenia z internetem. Spróbuj ponownie.',
  DioException(response: Response(statusCode: 503)) =>
    'Usługa jest chwilowo niedostępna. Spróbuj ponownie później.',
  _ => 'Nie udało się zmienić hasła.',
};
