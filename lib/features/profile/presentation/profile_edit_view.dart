import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/auth/shared/validation/auth_validators.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/presentation/profile_messages.dart';
import 'package:mobile_zpi/router/app_router.gr.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class ProfileEditView extends HookConsumerWidget {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final firstNameError = useState<String?>(null);
    final lastNameError = useState<String?>(null);
    final saveError = useState<String?>(null);
    final saving = useState(false);
    final filled = useRef(false);

    final account = profile.asData?.value;
    useEffect(() {
      if (account == null || filled.value) return null;
      filled.value = true;
      firstNameController.text = account.firstName;
      lastNameController.text = account.lastName;
      return null;
    }, [account]);

    Future<void> onSave() async {
      final current = profile.asData?.value;
      if (current == null || saving.value) return;

      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      firstNameError.value = AuthValidators.firstName(firstName);
      lastNameError.value = AuthValidators.lastName(lastName);
      saveError.value = null;
      if (firstNameError.value != null || lastNameError.value != null) return;

      saving.value = true;
      try {
        await ref
            .read(profileControllerProvider.notifier)
            .updateName(firstName: firstName, lastName: lastName);
        if (context.mounted) context.router.pop();
      } catch (error) {
        saveError.value = saveErrorMessage(error);
      } finally {
        saving.value = false;
      }
    }

    return BackScaffold(
      title: 'Edycja profilu',
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Nie udało się wczytać profilu.')),
        data: (_) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Możesz zmienić imię i nazwisko. Telefon i e-mail zostają bez zmian.',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextInput(
              controller: firstNameController,
              label: 'Imię',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              errorText: firstNameError.value,
              onChanged: (_) => firstNameError.value = null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextInput(
              controller: lastNameController,
              label: 'Nazwisko',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              errorText: lastNameError.value,
              onChanged: (_) => lastNameError.value = null,
              onSubmitted: (_) => onSave(),
            ),
            if (saveError.value != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                saveError.value!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: 'Zapisz',
              onPressed: saving.value ? null : onSave,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.secondary(
              label: 'Edytuj adres',
              onPressed: saving.value
                  ? null
                  : () => context.router.push(const AddressEditRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
