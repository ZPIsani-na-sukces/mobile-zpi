import 'package:mobile_zpi/keys.dart';

import '../common/test_app.dart';
import '../common/test_data.dart';

void main() {
  testApp('senior opens a task and a geozone from Home', (
    $,
    modules,
    system,
  ) async {
    await modules.home.openTask(TestData.taskOccurrenceId);
    await $(keys.routineTask.page).waitUntilVisible();
    await modules.navigation.goBack();
    await modules.home.openZone(TestData.zoneId);
    await system.allowLocation();
    await $(keys.geozone.page).waitUntilVisible();
  });
}
