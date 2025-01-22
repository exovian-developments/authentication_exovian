import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/auth_repository.dart';

part 'sign_up_viewmodel.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() {
      print('[signUpProvider] disposed');
      _key = null;
    });
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();

    final key = _key;

    final newState = await AsyncValue.guard<void>(
      () => ref.read(authRepositoryProvider).signUp(
            name: name,
            email: email,
            password: password,
          ),
    );

    if (key == _key) {
      state = newState;
    }
  }
}
