import 'package:mobile_zpi/features/auth/data/models/register_request.dart';
import 'package:mobile_zpi/features/auth/data/models/register_response.dart';
import 'package:mobile_zpi/features/auth/data/repository/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<RegisterResponse?> build() => null;

  Future<void> register(RegisterRequest request) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(request),
    );
    if (ref.mounted) state = result;
  }

  void clearError() {
    if (state.hasError && !state.isLoading) state = const AsyncData(null);
  }
}
