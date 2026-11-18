import 'package:mobile_zpi/features/auth/pass_reset/models/reset_channel.dart';
import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_reset_pass_code_controller.g.dart';

@riverpod
class SendResetPassCodeController extends _$SendResetPassCodeController {
  @override
  FutureOr<PhoneChallenge?> build() => null;

  Future<void> send(ResetChannel channel, String identifier) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendResetCode(channel, identifier),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
