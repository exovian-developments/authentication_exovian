import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/model/app_user.dart';
import '../../../data/repository/profile_repository.dart';

part 'profile_provider.g.dart';

@riverpod
FutureOr<AppUser> profile(Ref ref, String uid) {
  return ref.watch(profileRepositoryProvider).getProfile(uid: uid);
}
