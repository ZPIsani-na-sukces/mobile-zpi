import 'package:mobile_zpi/features/auth/shared/data/auth_repository.dart';
import 'package:mobile_zpi/features/auth/shared/data/models/phone_challenge.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_acc_activation_code_controller.g.dart';

@riverpod
class SendAccActivationCodeController
    extends _$SendAccActivationCodeController {
  @override
  FutureOr<PhoneChallenge?> build() => null;

  Future<void> send(String verificationTicket) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .sendActivationCode(verificationTicket),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
