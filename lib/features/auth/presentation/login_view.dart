import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/controllers/login_controller.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:mobile_zpi/features/auth/presentation/widgets/logo_placeholder.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_shadows.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';

@RoutePage()
class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identifierController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordHidden = useState(true);
    final identifierError = useState<String?>(null);
    final passwordError = useState<String?>(null);

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    ref.listen(loginControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next is AsyncData) {
        context.router.replaceAll([const AppRoute()]);
      }
    });

    void onLogin() {
      final identifier = identifierController.text.trim();
      final password = passwordController.text;
      identifierError.value = identifier.isEmpty
          ? 'Wpisz e-mail lub numer telefonu'
          : null;
      passwordError.value = password.isEmpty ? 'Wpisz hasło' : null;
      if (identifier.isEmpty || password.isEmpty) return;

      FocusScope.of(context).unfocus();
      ref.read(loginControllerProvider.notifier).login(identifier, password);
    }

    void onForgotPassword() {}
    void onSignUp() => context.router.push(const RegisterRoute());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              spacing: AppSpacing.xl,
              children: [
                const LogoPlaceholder(),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.xxlAll,
                    boxShadow: AppShadows.sm,
                  ),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpacing.md,
                      children: [
                        const Column(
                          spacing: AppSpacing.xs,
                          children: [
                            Text(
                              'Witaj ponownie!',
                              textAlign: TextAlign.center,
                              style: AppTypography.headlineSmall,
                            ),
                            Text(
                              'Zaloguj się, aby kontynuować',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppTextInput(
                          label: 'E-mail lub numer telefonu',
                          hintText: 'np. jan@kowalski.pl',
                          controller: identifierController,
                          leadingIcon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          errorText: identifierError.value,
                          onChanged: (_) => identifierError.value = null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.xs,
                          children: [
                            AppTextInput(
                              label: 'Hasło',
                              hintText: 'Wpisz hasło',
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
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              errorText: passwordError.value,
                              onChanged: (_) => passwordError.value = null,
                              onSubmitted: (_) => onLogin(),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppButton.text(
                                label: 'Nie pamiętasz hasła?',
                                onPressed: onForgotPassword,
                              ),
                            ),
                          ],
                        ),
                        if (loginState.error case final error?)
                          Text(
                            _loginErrorMessage(error),
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppButton.primary(
                              label: isLoading ? 'Logowanie…' : 'Zaloguj się',
                              onPressed: isLoading ? null : onLogin,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Nie masz konta?',
                                  style: AppTypography.bodyMedium,
                                ),
                                AppButton.text(
                                  label: 'Zarejestruj się',
                                  onPressed: onSignUp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _loginErrorMessage(Object error) => switch (error) {
  InvalidCredentialsException() => 'Nieprawidłowy login lub hasło',
  DioException(
    type: DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout,
  ) =>
    'Brak połączenia z internetem. Spróbuj ponownie.',
  _ => 'Coś poszło nie tak. Spróbuj ponownie.',
};
