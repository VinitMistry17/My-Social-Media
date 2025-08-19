
//auth repository outlines the possible auth operations for this app

import '../entities/app_user.dart';

abstract class AuthRepo{
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> signUpWithEmailAndPassword(String name,String email, String password);
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();

}