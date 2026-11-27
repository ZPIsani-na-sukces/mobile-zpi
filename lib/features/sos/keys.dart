import 'package:flutter/widgets.dart';
import 'package:mobile_zpi/features/sos/controllers/sos_controller.dart';

class _SosKey extends ValueKey<String> {
  const _SosKey(String value) : super('sos_$value');
}

class SosKeys {
  final closeButton = const _SosKey('closeButton');
  final locationMissingRow = const _SosKey('locationMissingRow');
  final locationSentRow = const _SosKey('locationSentRow');
  ValueKey<String> status(SosPhase phase) => _SosKey('status_${phase.name}');
}
