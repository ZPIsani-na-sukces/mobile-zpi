import 'package:flutter/material.dart';
import 'package:mobile_zpi/features/invitations/presentation/widgets/scanner_scrim_painter.dart';
import 'package:mobile_zpi/theme/app_colors.dart';
import 'package:mobile_zpi/theme/app_radius.dart';
import 'package:mobile_zpi/theme/app_spacing.dart';
import 'package:mobile_zpi/theme/app_typography.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key, required this.invalidCode});

  final bool invalidCode;

  static const double _frameSize = 240;
  static const double _frameWidth = 4;
  static const double _scrimOpacity = 0.7;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final window = Rect.fromCenter(
          center: size.center(Offset.zero),
          width: _frameSize,
          height: _frameSize,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerScrimPainter(
                  color: Colors.black.withValues(alpha: _scrimOpacity),
                  window: window,
                  radius: const Radius.circular(AppRadius.xl),
                ),
              ),
            ),
            Positioned.fromRect(
              rect: window,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.surface, width: _frameWidth),
                  borderRadius: AppRadius.xlAll,
                ),
              ),
            ),
            Positioned(
              top: window.bottom + AppSpacing.lg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Center(
                child: invalidCode
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.error,
                          borderRadius: AppRadius.lgAll,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            'To nie jest kod zaproszenia. Zeskanuj kod QR od opiekuna.',
                            textAlign: TextAlign.center,
                            style: AppTypography.titleMedium.copyWith(
                              color: colors.onError,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Zeskanuj kod QR na ekranie opiekuna, aby dodać go do listy opiekunów',
                        textAlign: TextAlign.center,
                        style: AppTypography.titleMedium.copyWith(
                          color: colors.surface,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
