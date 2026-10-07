import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class PlaygroudView extends HookWidget {
  const PlaygroudView({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {}

    final passwordHidden = useState(true);
    final filledController = useTextEditingController(text: 'Jan Kowalski');
    final successController = useTextEditingController(text: 'jan.kowalski');
    final errorController = useTextEditingController(text: 'jan@');
    final disabledController = useTextEditingController(text: 'Niedostępne');
    final readOnlyController = useTextEditingController(
      text: 'PESEL 90010112345',
    );
    final clearableController = useTextEditingController(text: 'Warszawa');

    return BackScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            const Center(
              child: Text('Przyciski', style: AppTypography.headlineSmall),
            ),
            const Text('Główny', style: AppTypography.titleMedium),
            AppButton.primary(label: 'Główny', onPressed: onPressed),
            AppButton.primary(
              label: 'Z ikoną',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.primary(label: 'Nieaktywny', onPressed: null),

            const Text('Drugorzędny', style: AppTypography.titleMedium),
            AppButton.secondary(label: 'Drugorzędny', onPressed: onPressed),
            AppButton.secondary(
              label: 'Z ikoną',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.secondary(label: 'Nieaktywny', onPressed: null),

            const Text('Tekstowy', style: AppTypography.titleMedium),
            AppButton.text(label: 'Tekstowy', onPressed: onPressed),
            AppButton.text(
              label: 'Z ikoną',
              icon: Icons.add,
              onPressed: onPressed,
            ),
            const AppButton.text(label: 'Nieaktywny', onPressed: null),

            const Text('Pełna szerokość', style: AppTypography.titleMedium),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                label: 'Pełna szerokość',
                onPressed: onPressed,
              ),
            ),

            const SizedBox(height: AppSpacing.md),
            const Center(
              child: Text('Pola tekstowe', style: AppTypography.headlineSmall),
            ),
            const Text('Domyślne', style: AppTypography.titleMedium),
            const AppTextInput(label: 'Imię', hintText: 'Wpisz imię'),
            const AppTextInput(hintText: 'Bez etykiety'),

            const Text('Wypełnione', style: AppTypography.titleMedium),
            AppTextInput(
              label: 'Imię i nazwisko',
              controller: filledController,
            ),

            const Text(
              'Tekst pomocniczy, opcjonalność i licznik',
              style: AppTypography.titleMedium,
            ),
            const AppTextInput(
              label: 'Telefon',
              hintText: '+48 000 000 000',
              helperText: 'Użyjemy go tylko w nagłych przypadkach',
              optionalText: 'Opcjonalne',
              keyboardType: TextInputType.phone,
            ),
            const AppTextInput(
              label: 'Opis',
              hintText: 'Napisz kilka słów',
              maxLength: 40,
            ),

            const Text('Ikony', style: AppTypography.titleMedium),
            const AppTextInput(
              label: 'Szukaj',
              hintText: 'Szukaj leków',
              leadingIcon: Icons.search,
            ),
            AppTextInput(
              label: 'Hasło',
              hintText: 'Wpisz hasło',
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
            ),
            AppTextInput(
              label: 'Miasto',
              controller: clearableController,
              trailingIcon: Icons.close,
              trailingIconTooltip: 'Wyczyść',
              onTrailingIconPressed: clearableController.clear,
            ),

            const Text('Walidacja', style: AppTypography.titleMedium),
            AppTextInput(
              label: 'E-mail',
              controller: errorController,
              leadingIcon: Icons.mail_outline,
              errorText: 'Niepoprawny adres e-mail',
            ),
            AppTextInput(
              label: 'Login',
              controller: successController,
              helperText: 'Login jest dostępny',
              isSuccess: true,
            ),

            const Text(
              'Nieaktywne i tylko do odczytu',
              style: AppTypography.titleMedium,
            ),
            AppTextInput(
              label: 'Nieaktywne',
              controller: disabledController,
              leadingIcon: Icons.person_outline,
              helperText: 'Tego pola nie można edytować',
              enabled: false,
            ),
            const AppTextInput(
              label: 'Nieaktywne (puste)',
              hintText: 'Tekst zastępczy',
              enabled: false,
            ),
            AppTextInput(
              label: 'Tylko do odczytu',
              controller: readOnlyController,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
