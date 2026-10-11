import 'package:url_launcher/url_launcher.dart';

class PhoneCallException implements Exception {
  const PhoneCallException();
}

Future<void> callPhone(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  final opened = await launchUrl(uri);
  if (!opened) throw const PhoneCallException();
}
