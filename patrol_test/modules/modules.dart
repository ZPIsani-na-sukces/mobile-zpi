import 'package:patrol/patrol.dart';

import 'auth.dart';
import 'caretakers.dart';
import 'contacts.dart';
import 'geozone.dart';
import 'home.dart';
import 'navigation.dart';
import 'profile.dart';
import 'sos.dart';

final class Modules {
  Modules(this._$);

  final PatrolIntegrationTester _$;

  late final auth = Auth(_$);
  late final caretakers = Caretakers(_$);
  late final contacts = Contacts(_$);
  late final geozone = Geozone(_$);
  late final home = Home(_$);
  late final navigation = Navigation(_$);
  late final profile = Profile(_$);
  late final sos = Sos(_$);
}
