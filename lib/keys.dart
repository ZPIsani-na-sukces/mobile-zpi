import 'package:mobile_zpi/features/auth/keys.dart';
import 'package:mobile_zpi/features/contacts/keys.dart';
import 'package:mobile_zpi/features/geozones/keys.dart';
import 'package:mobile_zpi/features/home/keys.dart';
import 'package:mobile_zpi/features/invitations/keys.dart';
import 'package:mobile_zpi/features/profile/keys.dart';
import 'package:mobile_zpi/features/routine/keys.dart';
import 'package:mobile_zpi/features/sos/keys.dart';
import 'package:mobile_zpi/widgets/keys.dart';

final keys = Keys();

class Keys {
  final acceptInvitation = AcceptInvitationKeys();
  final accActivation = AccActivationKeys();
  final addCaretaker = AddCaretakerKeys();
  final caretakers = CaretakersKeys();
  final contactChange = ContactChangeKeys();
  final contactDetails = ContactDetailsKeys();
  final contacts = ContactsKeys();
  final geozone = GeozoneKeys();
  final home = HomeKeys();
  final login = LoginKeys();
  final profile = ProfileKeys();
  final profileEdit = ProfileEditKeys();
  final register = RegisterKeys();
  final resetPass = ResetPassKeys();
  final routineTask = RoutineTaskKeys();
  final sendInvitation = SendInvitationKeys();
  final sos = SosKeys();
  final widgets = WidgetKeys();
}
