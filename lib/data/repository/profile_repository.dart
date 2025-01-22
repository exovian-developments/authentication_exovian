import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../constants/firebase_constants.dart';
import '../../utils/exception_handler.dart';
import '../model/app_user.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  Future<AppUser> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot appUserDoc = await usersCollection.doc(uid).get();

      if (appUserDoc.exists) {
        final appUser = AppUser.fromDoc(appUserDoc);
        return appUser;
      }

      throw 'User not found';
    } catch (error) {
      throw handleException(error);
    }
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository();
}
