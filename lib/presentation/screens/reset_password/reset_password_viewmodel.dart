import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/auth_repository.dart';

part 'reset_password_viewmodel.g.dart';

@riverpod
class ResetPasswordViewModel extends _$ResetPasswordViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> resetPassword({required String email}) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard<void>(
      () => ref.read(authRepositoryProvider).sendPasswordResetEmail(email),
    );
  }
}
