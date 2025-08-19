import 'package:my_social_media/features/auth/domain/repos/auth_repo.dart';

import '../domain/entities/app_user.dart';

class FirebaseAuthRepo implements AuthRepo{
  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
  @override
  Future<AppUser?> signUpWithEmailAndPassword(String name, String email, String password) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }
  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}