import 'package:mobile_zpi/features/sos/controllers/sos_controller.dart';
import 'package:mobile_zpi/keys.dart';

import 'module.dart';

final class Sos extends Module {
  Sos(super.$);

  Future<void> waitUntilSent() async {
    await $(keys.sos.status(SosPhase.waiting)).waitUntilExists();
  }

  Future<void> close() async {
    await $(keys.sos.closeButton).tap();
  }
}
