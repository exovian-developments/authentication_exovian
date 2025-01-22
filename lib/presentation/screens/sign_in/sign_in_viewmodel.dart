import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/auth_repository.dart';

part 'sign_in_viewmodel.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Sign in logic
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          ),
    );
  }
}
