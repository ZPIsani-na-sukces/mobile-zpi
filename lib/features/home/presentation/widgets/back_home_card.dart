import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_zpi/features/home/presentation/navigate_back_home.dart';
import 'package:mobile_zpi/features/profile/controllers/home_address_controller.dart';
import 'package:mobile_zpi/widgets/app_action_card.dart';

class BackHomeCard extends ConsumerWidget {
  const BackHomeCard({super.key, required this.seniorId});

  final String seniorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = homeAddressControllerProvider(seniorId);
    final address = ref.watch(provider);

    return AppActionCard.filled(
      icon: Icons.home_rounded,
      title: 'Wróć do domu',
      subtitle: switch (address) {
        AsyncData(value: final home?) => home.formattedAddress,
        AsyncData() => 'Brak ustawionego adresu',
        AsyncError() => 'Nie udało się wczytać adresu',
        AsyncLoading() => 'Wczytywanie adresu…',
      },
      onTap: switch (address) {
        AsyncData(value: final home) => () => navigateBackHome(
          context,
          seniorId: seniorId,
          home: home,
        ),
        AsyncError() => () {
          ref.invalidate(provider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nie udało się wczytać adresu domu.')),
          );
        },
        AsyncLoading() => null,
      },
    );
  }
}
