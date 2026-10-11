import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/features/profile/controllers/profile_controller.dart';
import 'package:mobile_zpi/features/profile/data/device_location.dart';
import 'package:mobile_zpi/features/profile/data/models/home_address.dart';
import 'package:mobile_zpi/features/profile/data/repository/profile_repository.dart';
import 'package:mobile_zpi/features/profile/presentation/profile_messages.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';
import 'package:mobile_zpi/widgets/app_button.dart';
import 'package:mobile_zpi/widgets/app_text_input.dart';
import 'package:mobile_zpi/widgets/back_scaffold.dart';

@RoutePage()
class AddressEditView extends HookConsumerWidget {
  const AddressEditView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final account = profile.asData?.value;

    return BackScaffold(
      title: 'Adres domu',
      body: switch (profile) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError() => const Center(
          child: Text('Nie udało się wczytać profilu.'),
        ),
        AsyncData() when account != null => _AddressForm(
          seniorId: account.userId,
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _AddressForm extends HookConsumerWidget {
  const _AddressForm({required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(homeAddressControllerProvider(seniorId));
    final countryController = useTextEditingController(text: 'PL');
    final postalController = useTextEditingController();
    final cityController = useTextEditingController();
    final streetController = useTextEditingController();
    final buildingController = useTextEditingController();
    final apartmentController = useTextEditingController();
    final coordinates = useState<Coordinates?>(null);
    final countryError = useState<String?>(null);
    final postalError = useState<String?>(null);
    final cityError = useState<String?>(null);
    final buildingError = useState<String?>(null);
    final formError = useState<String?>(null);
    final saving = useState(false);
    final detecting = useState(false);
    final filled = useRef(false);

    final address = addressState.asData?.value;
    useEffect(() {
      if (!addressState.hasValue || filled.value) return null;
      filled.value = true;
      if (address == null) return null;
      countryController.text = address.countryCode;
      postalController.text = address.postalCode;
      cityController.text = address.city;
      streetController.text = address.street ?? '';
      buildingController.text = address.buildingNumber;
      apartmentController.text = address.apartmentNumber ?? '';
      coordinates.value = address.coordinates;
      return null;
    }, [addressState.hasValue, address]);

    Future<void> onDetect() async {
      if (detecting.value || saving.value) return;
      detecting.value = true;
      formError.value = null;
      try {
        final location = await readCurrentLocation();
        final detected = await ref
            .read(profileRepositoryProvider)
            .detectHomeAddress(
              seniorId: seniorId,
              latitude: location.latitude,
              longitude: location.longitude,
            );
        final geocoded = detected.address;
        final country = geocoded.countryCode?.toUpperCase();
        if (country != null && country.length == 2) {
          countryController.text = country;
        }
        postalController.text = geocoded.postcode ?? postalController.text;
        cityController.text =
            geocoded.city ??
            geocoded.town ??
            geocoded.village ??
            cityController.text;
        streetController.text = geocoded.road ?? streetController.text;
        buildingController.text =
            geocoded.houseNumber ?? buildingController.text;
        coordinates.value = detected.coordinates;
      } on LocationException catch (error) {
        formError.value = error.message;
      } catch (_) {
        formError.value = 'Nie udało się wykryć adresu. Wpisz go ręcznie.';
      } finally {
        detecting.value = false;
      }
    }

    Future<void> onSave() async {
      if (saving.value || !addressState.hasValue) return;
      final country = countryController.text.trim().toUpperCase();
      final postal = postalController.text.trim();
      final city = cityController.text.trim();
      final street = streetController.text.trim();
      final building = buildingController.text.trim();
      final apartment = apartmentController.text.trim();
      countryController.text = country;

      countryError.value = RegExp(r'^[A-Z]{2}$').hasMatch(country)
          ? null
          : 'Wpisz dwuliterowy kod kraju, np. PL';
      postalError.value = postal.isEmpty ? 'Wpisz kod pocztowy' : null;
      cityError.value = city.isEmpty ? 'Wpisz miasto' : null;
      buildingError.value = building.isEmpty ? 'Wpisz numer budynku' : null;
      formError.value = coordinates.value == null
          ? 'Użyj bieżącej lokalizacji, żeby ustalić współrzędne domu.'
          : null;
      if (countryError.value != null ||
          postalError.value != null ||
          cityError.value != null ||
          buildingError.value != null ||
          coordinates.value == null) {
        return;
      }

      saving.value = true;
      try {
        await ref
            .read(homeAddressControllerProvider(seniorId).notifier)
            .save(
              HomeAddressInput(
                countryCode: country,
                postalCode: postal,
                city: city,
                street: street.isEmpty ? null : street,
                buildingNumber: building,
                apartmentNumber: apartment.isEmpty ? null : apartment,
                coordinates: coordinates.value!,
              ),
            );
        if (context.mounted) context.router.pop();
      } catch (error) {
        formError.value = saveErrorMessage(error);
      } finally {
        saving.value = false;
      }
    }

    if (addressState.isLoading && !addressState.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    if (addressState.hasError && !addressState.hasValue) {
      return const Center(child: Text('Nie udało się wczytać adresu.'));
    }

    final busy = saving.value || detecting.value;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Adres domu służy do wyznaczenia drogi powrotnej.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          label: detecting.value
              ? 'Wykrywanie adresu...'
              : 'Użyj bieżącej lokalizacji',
          icon: Icons.my_location,
          onPressed: busy ? null : onDetect,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextInput(
          controller: countryController,
          label: 'Kraj',
          hintText: 'PL',
          maxLength: 2,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
          ],
          errorText: countryError.value,
          onChanged: (_) => countryError.value = null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          controller: postalController,
          label: 'Kod pocztowy',
          errorText: postalError.value,
          onChanged: (_) => postalError.value = null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          controller: cityController,
          label: 'Miasto',
          textCapitalization: TextCapitalization.words,
          errorText: cityError.value,
          onChanged: (_) => cityError.value = null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          controller: streetController,
          label: 'Ulica',
          optionalText: 'Opcjonalnie',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          controller: buildingController,
          label: 'Numer budynku',
          errorText: buildingError.value,
          onChanged: (_) => buildingError.value = null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          controller: apartmentController,
          label: 'Numer mieszkania',
          optionalText: 'Opcjonalnie',
        ),
        if (formError.value != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            formError.value!,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Zapisz adres',
          onPressed: busy ? null : onSave,
        ),
      ],
    );
  }
}
