import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_social_media/features/search/domain/search_repo.dart';

import '../../profile/domain/entities/profile_user.dart';

class FirebaseSearchRepo implements SearchRepo{
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try{
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();


    } catch(e){
      throw Exception('Failed to search users: $e');
    }
  }
}
