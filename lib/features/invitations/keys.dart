import 'package:flutter/widgets.dart';

class _CaretakersKey extends ValueKey<String> {
  const _CaretakersKey(String value) : super('caretakers_$value');
}

class CaretakersKeys {
  final addButton = const _CaretakersKey('addButton');
  ValueKey<String> card(String relationshipId) =>
      _CaretakersKey('card_$relationshipId');
  ValueKey<String> removeButton(String relationshipId) =>
      _CaretakersKey('removeButton_$relationshipId');
  final removeConfirmButton = const _CaretakersKey('removeConfirmButton');
}

class _AddCaretakerKey extends ValueKey<String> {
  const _AddCaretakerKey(String value) : super('addCaretaker_$value');
}

class AddCaretakerKeys {
  final enterCodeButton = const _AddCaretakerKey('enterCodeButton');
  final showMyCodeButton = const _AddCaretakerKey('showMyCodeButton');
}

class _AcceptInvitationKey extends ValueKey<String> {
  const _AcceptInvitationKey(String value) : super('acceptInvitation_$value');
}

class AcceptInvitationKeys {
  final acceptButton = const _AcceptInvitationKey('acceptButton');
  final codeInput = const _AcceptInvitationKey('codeInput');
}

class _SendInvitationKey extends ValueKey<String> {
  const _SendInvitationKey(String value) : super('sendInvitation_$value');
}

class SendInvitationKeys {
  final code = const _SendInvitationKey('code');
  final copyButton = const _SendInvitationKey('copyButton');
}
