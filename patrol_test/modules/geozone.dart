import 'package:mobile_zpi/keys.dart';

import 'module.dart';

final class Geozone extends Module {
  Geozone(super.$);

  Future<void> close() async {
    await $(keys.geozone.backButton).tap();
  }
}
