enum InvitationCodeError {
  invalid,
  notForYou,
  used,
  alreadyLinked,
  tooManyAttempts,
}

class InvitationCodeException implements Exception {
  const InvitationCodeException(this.error);

  final InvitationCodeError error;
}
