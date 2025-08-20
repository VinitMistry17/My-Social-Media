
//auth repository outlines the possible auth operations for this app

import '../entities/app_user.dart';

abstract class AuthRepo{
  Future<AppUser?> loginWithEmailAndPassword(String email, String password);
  Future<AppUser?> registerWithEmailAndPassword(String name,String email, String password);
  Future<void> logOut();
  Future<AppUser?> getCurrentUser();

}
