import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/post/presentation/cubits/post_states.dart';

// ✅ import profileCubit to refresh profile after post create/delete
import 'package:my_social_media/features/profile/presentation/cubits/profile_cubit.dart';

import '../../../storage/domain/storage_repo.dart';
import '../../domain/entities/comments.dart';
import '../../domain/entities/post.dart';
import '../../domain/repos/post_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  // 📝 create a new post
  Future<void> createPost(
      Post post, {
        String? imagePath,
        Uint8List? imageBytes,
        required ProfileCubit profileCubit, // ✅ Add required ProfileCubit parameter
      }) async {
    String? imageUrl;

    try {
      // upload image for mobile
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // upload image for web
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // copy post with imageUrl
      final newPost = post.copyWith(imageUrl: imageUrl);

      // ✅ save post in backend
      await postRepo.createPost(newPost);

      // ✅ refresh posts list
      fetchAllPosts();

      // ✅ refresh profile (so that postCount updates on profile page)
      await profileCubit.fetchUserProfile(post.userId);
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // 📥 fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // ❌ delete a post
  Future<void> deletePost(
      String postId,
      String userId, // 👈 add userId so we can refresh profile
      ProfileCubit profileCubit,
      ) async {
    try {
      await postRepo.deletePost(postId);
      await fetchAllPosts();

      // ✅ refresh profile after deleting post (so postCount updates)
      await profileCubit.fetchUserProfile(userId);
    } catch (e) {
      emit(PostsError("Failed to delete post: $e"));
    }
  }

  // ❤️ toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // 💬 add comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // 🗑️ delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}