import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:my_social_media/features/post/domain/repos/post_repo.dart';

import '../domain/entities/post.dart';

class FirebasePostRepo implements PostRepo{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //store the posts in collection called 'posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try{
      //get all post with the most recent post at the top
      final postSnapshot = await postsCollection.orderBy('timestamp', descending: true).get();
      //convert each firestore document from json -> list of posts
      final List<Post> allPosts = postSnapshot.docs.map((doc) =>
          Post.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return allPosts;
    } catch(e){
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try{
      //fetch snapshot with this uid
      final postSnapshot = await postsCollection.where('userId', isEqualTo: userId).get();

      //convert each firestore document from json -> list of posts
      final List<Post> userPosts = postSnapshot.docs.map((doc) =>
          Post.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return userPosts;
    } catch(e){
      throw Exception("Error fetching posts by user: $e");
    }
  }
}
