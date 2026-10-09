import 'package:mobile_zpi/features/auth/data/models/phone_challenge.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_activation_code_controller.g.dart';

@riverpod
class SendActivationCodeController extends _$SendActivationCodeController {
  @override
  FutureOr<PhoneChallenge?> build() => null;

  Future<void> send(String verificationTicket) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .sendVerificationCode(verificationTicket),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
