import 'package:go_router/go_router.dart';

import '../../presentation/screens/change_password/change_password_screen.dart';
import '../../presentation/screens/errors/firebase_error_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/reset_password/reset_password_screen.dart';
import '../../presentation/screens/sign_in/sign_in_screen.dart';
import '../../presentation/screens/sign_up/sign_up_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/verify_email/verify_email_screen.dart';
import 'route_names.dart';

List<GoRoute> routes = [
  GoRoute(
    path: '/splash',
    name: RouteNames.splash,
    builder: (context, state) {
      print('Splash screen!');
      return const SplashScreen();
    },
  ),
  GoRoute(
    path: '/firebase_error',
    name: RouteNames.firebaseError,
    builder: (context, state) {
      print('Firebase error screen!');
      return const FirebaseErrorScreen();
    },
  ),
  GoRoute(
    path: '/sign_in',
    name: RouteNames.signin,
    builder: (context, state) {
      print('SignIn screen!');
      return const SignInScreen();
    },
  ),
  GoRoute(
    path: '/sign_up',
    name: RouteNames.signup,
    builder: (context, state) {
      print('SignUp screen!');
      return const SignUpScreen();
    },
  ),
  GoRoute(
    path: '/reset_password',
    name: RouteNames.resetPassword,
    builder: (context, state) {
      print('Reset password screen!');
      return const ResetPasswordScreen();
    },
  ),
  GoRoute(
    path: '/verify_email',
    name: RouteNames.verifyEmail,
    builder: (context, state) {
      print('Verify email screen!');
      return const VerifyEmailScreen();
    },
  ),
  GoRoute(
    path: '/home',
    name: RouteNames.home,
    builder: (context, state) {
      print('Home screen!');
      return const HomeScreen();
    },
    routes: [
      GoRoute(
        path: '/change_password',
        name: RouteNames.changePassword,
        builder: (context, state) {
          print('Change password screen!');
          return const ChangePasswordScreen();
        },
      ),
    ],
  ),
];
