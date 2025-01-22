import 'package:firebase_auth/firebase_auth.dart';

import '../data/model/custom_error.dart';

CustomError handleException(e) {
  try {
    throw e;
  } on FirebaseAuthException catch (error) {
    throw CustomError(
      code: error.code,
      message: error.message ?? 'Invalid credentials',
      plugin: error.plugin,
    );
  } on FirebaseException catch (error) {
    throw CustomError(
      code: error.code,
      message: error.message ?? 'Firebase Error',
      plugin: error.plugin,
    );
  } catch (e) {
    throw CustomError(
      code: 'Exception',
      message: e.toString(),
      plugin: 'Unknown error',
    );
  }
}
