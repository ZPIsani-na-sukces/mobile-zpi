// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State of the login form submission, separate from [AuthController] so a
/// login attempt doesn't put the whole app's session into loading.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// State of the login form submission, separate from [AuthController] so a
/// login attempt doesn't put the whole app's session into loading.
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// State of the login form submission, separate from [AuthController] so a
  /// login attempt doesn't put the whole app's session into loading.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'f82cffcbd9b243a8829b96467290f3b1dfb7c357';

/// State of the login form submission, separate from [AuthController] so a
/// login attempt doesn't put the whole app's session into loading.

abstract class _$LoginController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
