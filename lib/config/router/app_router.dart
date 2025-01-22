import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../constants/firebase_constants.dart';
import '../../data/repository/auth_repository.dart';
import '../../presentation/screens/errors/not_found_screen.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateStreamProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (authState is AsyncLoading<User?>) {
        return '/splash';
      }

      if (authState is AsyncError<User?>) {
        return '/firebase_error';
      }

      final authenticated = authState.valueOrNull != null;

      final authenticating = (state.matchedLocation == '/sign_in') ||
          (state.matchedLocation == '/sign_up') ||
          (state.matchedLocation == '/reset_password');

      if (authenticated == false) {
        return authenticating ? null : '/sign_in';
      }

      if (!firebaseAuth.currentUser!.emailVerified) {
        return '/verify_email';
      }

      final verifyingEmail = state.matchedLocation == '/verify_email';
      final splashing = state.matchedLocation == '/splash';

      return (authenticating || verifyingEmail || splashing) ? '/home' : null;
    },
    routes: routes,
    errorBuilder: (context, state) {
      return NotFoundScreen(
        errorMessage: state.error.toString(),
      );
    },
  );
}
