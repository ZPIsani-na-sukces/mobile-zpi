import 'package:mobile_zpi/features/sos/data/sos_alarm.dart';
import 'package:mobile_zpi/features/sos/data/sos_location.dart';
import 'package:mobile_zpi/features/sos/data/sos_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sos_controller.g.dart';

enum SosPhase { locating, sending, waiting, failed }

class SosFlow {
  const SosFlow({required this.phase, this.position, this.message, this.alarm});

  final SosPhase phase;
  final SosFix? position;
  final String? message;

  /// Set once the API accepted the press.
  final SosAlarm? alarm;
}

@riverpod
class SosController extends _$SosController {
  @override
  SosFlow build() => const SosFlow(phase: SosPhase.locating);

  Future<void> start(String seniorId) async {
    final position = await readSosFix();
    if (!ref.mounted) return;
    await _send(seniorId, position);
  }

  Future<void> _send(String seniorId, SosFix? position) async {
    state = SosFlow(phase: SosPhase.sending, position: position);
    try {
      final alarm = await ref
          .read(sosRepositoryProvider)
          .trigger(
            seniorId: seniorId,
            triggeredAt: DateTime.now().toUtc(),
            position: position,
          );
      if (!ref.mounted) return;
      state = SosFlow(
        phase: SosPhase.waiting,
        position: position,
        alarm: alarm,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = const SosFlow(
        phase: SosPhase.failed,
        message: 'Sprawdź połączenie z internetem i spróbuj ponownie.',
      );
    }
  }
}
