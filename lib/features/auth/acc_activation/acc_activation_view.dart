import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/acc_activation/controllers/activate_acc_controller.dart';
import 'package:mobile_zpi/features/auth/acc_activation/controllers/send_acc_activation_code_controller.dart';
import 'package:mobile_zpi/features/auth/acc_activation/models/activate_acc_request.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_exceptions.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/auth/shared/validation/auth_validators.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/resend_code_button.dart';
import 'package:mobile_zpi/features/auth/shared/widgets/step_card.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_code_input.dart';

@RoutePage()
class AccActivationView extends HookConsumerWidget {
  const AccActivationView({
    super.key,
    required this.verificationTicket,
    required this.identifier,
    required this.password,
    this.phoneNumber,
    this.initialChallenge,
  });

  final String verificationTicket;
  final String identifier;
  final String password;
  final String? phoneNumber;
  final PhoneChallenge? initialChallenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeController = useVerificationCodeController();
    final codeError = useState<String?>(null);
    final challenge = useState(initialChallenge);
    final resendAfter = useState(initialChallenge?.resendAfter);

    final sendState = ref.watch(sendAccActivationCodeControllerProvider);
    final activationState = ref.watch(activateAccControllerProvider);
    final isSending = sendState.isLoading;
    final isActivating = activationState.isLoading;

    void clearControllerErrors() {
      ref.read(sendAccActivationCodeControllerProvider.notifier).clearError();
      ref.read(activateAccControllerProvider.notifier).clearError();
    }

    void requestCode() {
      clearControllerErrors();
      ref
          .read(sendAccActivationCodeControllerProvider.notifier)
          .send(verificationTicket);
    }

    useEffect(() {
      if (initialChallenge == null) Future.microtask(requestCode);
      return null;
    }, const []);

    void returnToLogin(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
      );
      context.router.replaceAll([const LoginRoute()]);
    }

    ref.listen(sendAccActivationCodeControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      switch (next) {
        case AsyncData(value: final newChallenge?):
          challenge.value = newChallenge;
          resendAfter.value = newChallenge.resendAfter;
          codeController.clear();
          codeError.value = null;
        case AsyncError(error: TooManyAttemptsException(:final retryAfter?)):
          resendAfter.value = DateTime.now().add(retryAfter);
        case AsyncError(error: VerificationExpiredException()):
          returnToLogin(
            'Czas na potwierdzenie numeru minął. '
            'Zaloguj się, aby otrzymać nowy kod.',
          );
        default:
      }
    });

    ref.listen(activateAccControllerProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      switch (next) {
        case AsyncData():
          context.router.replaceAll([const AppRoute()]);
        case AsyncError(error: AutoLoginFailedException()):
          returnToLogin(
            'Numer telefonu został potwierdzony. Zaloguj się, aby kontynuować.',
          );
        case AsyncError(:final error) when _isCodeError(error):
          codeError.value = _accountVerificationErrorMessage(error);
        default:
      }
    });

    void onConfirm() {
      final currentChallenge = challenge.value;
      if (currentChallenge == null || isActivating) return;

      codeError.value = AuthValidators.verificationCode(codeController.text);
      if (codeError.value != null) return;

      FocusScope.of(context).unfocus();
      ref
          .read(activateAccControllerProvider.notifier)
          .activate(
            request: ActivateAccRequest(
              challengeId: currentChallenge.challengeId,
              code: codeController.text,
            ),
            identifier: identifier,
            password: password,
          );
    }

    void onFinishLater() => context.router.maybePop();

    final generalError = switch (activationState.error ?? sendState.error) {
      AutoLoginFailedException() || VerificationExpiredException() => null,
      final error? when !_isCodeError(error) => error,
      _ => null,
    };

    return Scaffold(
      body: SafeArea(
        child: StepCard(
          title: 'Potwierdź numer telefonu',
          subtitle: phoneNumber != null
              ? 'Wpisz kod z SMS wysłanego na numer $phoneNumber'
              : 'Wpisz kod z SMS wysłanego na numer przypisany do konta',
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                AppCodeInput(
                  label: 'Kod z SMS',
                  controller: codeController,
                  autoFocus: true,
                  errorText: codeError.value,
                  onChanged: (_) {
                    codeError.value = null;
                    clearControllerErrors();
                  },
                  onCompleted: (_) => onConfirm(),
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
                      resendAfter: resendAfter.value,
                      isLoading: isSending,
                      onPressed: requestCode,
                    ),
                  ],
                ),
              ],
            ),
            if (generalError != null)
              Text(
                _accountVerificationErrorMessage(generalError),
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
                  label: isActivating ? 'Potwierdzanie…' : 'Potwierdź',
                  onPressed: isActivating || challenge.value == null
                      ? null
                      : onConfirm,
                ),
                AppButton.secondary(
                  label: 'Dokończę później',
                  onPressed: isActivating ? null : onFinishLater,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

bool _isCodeError(Object error) =>
    error is InvalidCodeException || error is CodeExpiredException;

String _accountVerificationErrorMessage(Object error) => switch (error) {
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
  _ => 'Nie udało się potwierdzić numeru telefonu.',
};
