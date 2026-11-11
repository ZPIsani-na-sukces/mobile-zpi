import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_zpi/features/geozones/presentation/widgets/map_circle_button.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/scanner_overlay.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/widgets/app_message.dart';

@RoutePage()
class ScanInvitationView extends HookWidget {
  const ScanInvitationView({super.key});

  static final _codePattern = RegExp(r'^[0-9]{6}$');

  @override
  Widget build(BuildContext context) {
    final handled = useRef(false);
    final invalidCode = useState(false);

    void onDetect(BarcodeCapture capture) {
      if (handled.value) return;
      for (final barcode in capture.barcodes) {
        final value = barcode.rawValue?.trim();
        if (value != null && _codePattern.hasMatch(value)) {
          handled.value = true;
          context.router.pop(value);
          return;
        }
      }
      invalidCode.value = true;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            onDetect: onDetect,
            overlayBuilder: (context, _) =>
                ScannerOverlay(invalidCode: invalidCode.value),
            errorBuilder: (context, error) => ColoredBox(
              color: context.colors.background,
              child: switch (error.errorCode) {
                MobileScannerErrorCode.permissionDenied => const AppMessage(
                  text: 'Aplikacja nie ma dostępu do aparatu. Zezwól na niego w ustawieniach.',
                  actionLabel: 'Otwórz ustawienia',
                  onPressed: Geolocator.openAppSettings,
                ),
                _ => const AppMessage(text: 'Nie udało się uruchomić aparatu.'),
              },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MapCircleButton(
                  tooltip: 'Zamknij',
                  icon: const Icon(Icons.close),
                  onPressed: () => context.router.pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
