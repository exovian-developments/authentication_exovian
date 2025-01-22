import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/auth_repository.dart';

part 'change_password_viewmodel.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword(String password) async {
    state = const AsyncLoading<void>();

    state = await AsyncValue.guard<void>(
      () => ref.read(authRepositoryProvider).changePassword(password),
    );
  }
}
