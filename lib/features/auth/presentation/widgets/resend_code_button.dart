import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_zpi/widgets/app_button.dart';

class ResendCodeButton extends HookWidget {
  const ResendCodeButton({
    super.key,
    required this.resendAfter,
    required this.onPressed,
    this.isLoading = false,
  });

  final DateTime? resendAfter;
  final VoidCallback onPressed;
  final bool isLoading;

  static const _tick = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final rebuild = useState(0);

    useEffect(() {
      final timer = Timer.periodic(_tick, (timer) {
        rebuild.value++;
        if (_remainingSeconds() <= 0) timer.cancel();
      });
      return timer.cancel;
    }, [resendAfter]);

    final remaining = _remainingSeconds();

    if (isLoading) {
      return const AppButton.text(label: 'Wysyłanie…', onPressed: null);
    }
    if (remaining > 0) {
      return AppButton.text(
        label: 'Wyślij ponownie za ${_format(remaining)}',
        onPressed: null,
      );
    }
    return AppButton.text(label: 'Wyślij kod ponownie', onPressed: onPressed);
  }

  int _remainingSeconds() {
    final after = resendAfter;
    if (after == null) return 0;
    final millis = after.difference(DateTime.now()).inMilliseconds;
    return millis <= 0 ? 0 : (millis / 1000).ceil();
  }

  String _format(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}
