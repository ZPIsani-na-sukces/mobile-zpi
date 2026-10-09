import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/controllers/register_controller.dart';
import 'package:mobile_zpi/features/auth/data/models/register_request.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:mobile_zpi/features/auth/presentation/widgets/step_card.dart';
import 'package:mobile_zpi/features/auth/presentation/widgets/step_progress.dart';
import 'package:mobile_zpi/features/auth/validation/auth_validators.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';

const _stepCount = 2;
const _pageTransitionDuration = Duration(milliseconds: 300);

@RoutePage()
class RegisterView extends HookConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentStep = useState(0);

    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final passwordHidden = useState(true);
    final repeatPasswordHidden = useState(true);

    final firstNameError = useState<String?>(null);
    final lastNameError = useState<String?>(null);
    final phoneError = useState<String?>(null);
    final emailError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final repeatPasswordError = useState<String?>(null);

    final registerState = ref.watch(registerControllerProvider);
    final isLoading = registerState.isLoading;

    void goToStep(int step) {
      FocusScope.of(context).unfocus();
      pageController.animateToPage(
        step,
        duration: _pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }

    void onNext() {
      firstNameError.value = AuthValidators.firstName(firstNameController.text);
      lastNameError.value = AuthValidators.lastName(lastNameController.text);
      phoneError.value = AuthValidators.phoneNumber(phoneController.text);

      if (firstNameError.value != null ||
          lastNameError.value != null ||
          phoneError.value != null) {
        return;
      }

      goToStep(1);
    }

    ValueChanged<String> clearErrors(ValueNotifier<String?> fieldError) => (_) {
      fieldError.value = null;
      ref.read(registerControllerProvider.notifier).clearError();
    };

    ref.listen(registerControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      if (next case AsyncData(value: final response?)) {
        final phoneNumber = AuthValidators.normalizePhoneNumber(
          phoneController.text,
        )!;
        context.router.replace(
          AccountVerificationRoute(
            verificationTicket: response.verificationTicket,
            identifier: phoneNumber,
            password: passwordController.text,
            phoneNumber: phoneNumber,
            initialChallenge: response.phoneChallenge,
          ),
        );
      }
    });

    void onBack() => goToStep(0);

    void onRegister() {
      final password = passwordController.text;
      emailError.value = AuthValidators.email(emailController.text);
      passwordError.value = AuthValidators.password(password);
      repeatPasswordError.value = AuthValidators.repeatPassword(
        repeatPasswordController.text,
        password,
      );

      if (emailError.value != null ||
          passwordError.value != null ||
          repeatPasswordError.value != null) {
        return;
      }

      FocusScope.of(context).unfocus();

      ref
          .read(registerControllerProvider.notifier)
          .register(
            RegisterRequest(
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              phoneNumber: AuthValidators.normalizePhoneNumber(
                phoneController.text,
              )!,
              email: AuthValidators.normalizeEmail(emailController.text),
              password: password,
            ),
          );
    }

    void onSignIn() => context.router.maybePop();

    return PopScope(
      canPop: currentStep.value == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isLoading) onBack();
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
                      title: 'Utwórz konto',
                      subtitle: 'Najpierw powiedz nam coś o sobie',
                      children: [
                        AppTextInput(
                          label: 'Imię',
                          hintText: 'np. Jan',
                          controller: firstNameController,
                          leadingIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.givenName],
                          errorText: firstNameError.value,
                          onChanged: clearErrors(firstNameError),
                        ),
                        AppTextInput(
                          label: 'Nazwisko',
                          hintText: 'np. Kowalski',
                          controller: lastNameController,
                          leadingIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.familyName],
                          errorText: lastNameError.value,
                          onChanged: clearErrors(lastNameError),
                        ),
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
                          onSubmitted: (_) => onNext(),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppButton.primary(
                              label: 'Dalej',
                              onPressed: onNext,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Masz już konto?',
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
                      title: 'Dane logowania',
                      subtitle: 'Ustaw e-mail i hasło do konta',
                      children: [
                        AppTextInput(
                          label: 'E-mail',
                          optionalText: 'Opcjonalne',
                          hintText: 'np. jan@kowalski.pl',
                          controller: emailController,
                          leadingIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          errorText: emailError.value,
                          onChanged: clearErrors(emailError),
                        ),
                        AppTextInput(
                          label: 'Hasło',
                          hintText: 'Wpisz hasło',
                          helperText: 'Co najmniej 12 znaków',
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
                        AppTextInput(
                          label: 'Powtórz hasło',
                          hintText: 'Wpisz hasło ponownie',
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
                          onSubmitted: (_) => onRegister(),
                        ),
                        if (registerState.error case final error?)
                          Text(
                            _registerErrorMessage(error),
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.sm,
                          children: [
                            AppButton.primary(
                              label: isLoading
                                  ? 'Rejestrowanie…'
                                  : 'Zarejestruj się',
                              onPressed: isLoading ? null : onRegister,
                            ),
                            AppButton.secondary(
                              label: 'Wstecz',
                              onPressed: isLoading ? null : onBack,
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

String _registerErrorMessage(Object error) => switch (error) {
  AccountAlreadyExistsException() =>
    'Konto z tym numerem telefonu lub adresem e-mail już istnieje.',
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
  _ => 'Nie udało się utworzyć konta.',
};
