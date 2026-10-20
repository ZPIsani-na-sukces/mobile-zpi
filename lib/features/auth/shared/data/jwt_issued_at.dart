import 'dart:convert';

DateTime? jwtIssuedAt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;

  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    if (payload case {'iat': final num iat}) {
      return DateTime.fromMillisecondsSinceEpoch(
        iat.toInt() * 1000,
        isUtc: true,
      );
    }
  } on FormatException {
    return null;
  }
  return null;
}
