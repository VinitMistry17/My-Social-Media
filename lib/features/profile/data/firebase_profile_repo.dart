import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_social_media/features/profile/domain/entities/profile_user.dart';
import 'package:my_social_media/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try{
      //get user document from firestore
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if(userDoc.exists){
        final userData = userDoc.data();
        if (userData != null){
          //fetch followers & following from firebase
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          return ProfileUser(
              uid: uid,
              email: userData['email'],
              name: userData['name'],
              bio: userData['bio'] ?? '',
              profileImageUrl: userData['profileImageUrl'].toString(),
              followers: followers,
              following: following,
          );
        }
      }
      return null;
    }
    catch(e){
      throw Exception("failed to fetch user profile: $e");
    }
  }
  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      //convert updated profile to json to save in firestore
      await firebaseFirestore
          .collection('users')
          .doc(updatedProfile.uid)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });

    }
    catch(e){
      throw Exception("failed to update profile: $e");
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
      await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc =
      await firebaseFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        // raw firestore data
        final currentUserData = currentUserDoc.data()!;
        final targetUserData = targetUserDoc.data()!;

        // followers & following lists
        final List<String> currentFollowing =
        List<String>.from(currentUserData['following'] ?? []);
        final List<String> targetFollowers =
        List<String>.from(targetUserData['followers'] ?? []);

        // check if already following
        if (currentFollowing.contains(targetUid)) {
          // unfollow
          currentFollowing.remove(targetUid);
          targetFollowers.remove(currentUid);
        } else {
          // follow
          currentFollowing.add(targetUid);
          targetFollowers.add(currentUid);
        }

        // update both users
        await firebaseFirestore.collection('users').doc(currentUid).update({
          'following': currentFollowing,
        });

        await firebaseFirestore.collection('users').doc(targetUid).update({
          'followers': targetFollowers,
        });
      }
    } catch (e) {
      throw Exception("failed to toggle follow: $e");
    }
  }

}
