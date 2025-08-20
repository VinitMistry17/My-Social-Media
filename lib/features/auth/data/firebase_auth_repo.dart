import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_social_media/features/auth/domain/repos/auth_repo.dart';

import '../domain/entities/app_user.dart';

class FirebaseAuthRepo implements AuthRepo{

  //FirebaseAuth's single instance, used for login/logout/current user
  //FirebaseAuth = Firebase ka ready-made service hai jo login/logout ka kaam karta hai.
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailAndPassword(String email, String password) async {
    try {
      //attempt login
      //UserCredential = a package with user info for ex. email, name, uid etc..
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );

      //create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        // ! = trust me user is logged in and that's why its not a null
        email: email,
        name: '',
      );

      //return user
      return user;
    }
    //catch errors
    catch (e) {
      throw Exception("login failed: $e");
    }
  }
  @override
  Future<AppUser?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      //attempt signup
      //UserCredential = a package with user info for ex. email, name, uid etc..
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      //create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        // ! = trust me user is logged in and that's why its not a null
        email: email,
        name: name,
      );
      //return user
      return user;
    }
    //catch errors
    catch (e) {
      throw Exception("signup failed: $e");
    }
  }
  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
  @override
  Future<AppUser?> getCurrentUser() async {
    //get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    //if no user logged in
    if (firebaseUser == null) {
      return null;
    }
    //if user logged in
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: '',
    );
  }
}
