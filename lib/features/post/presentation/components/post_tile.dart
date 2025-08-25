import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/auth/presentation/components/my_text_field.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../domain/entities/comments.dart';
import '../../domain/entities/post.dart';
import '../cubits/post_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';
import '../cubits/post_states.dart';

// Import CommentTile
import 'comment_tile.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({
    required this.post,
    required this.onDeletePressed,
    super.key,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  final commentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Type a comment..",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void addComment() {
    if (commentTextController.text.isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    postCubit.addComment(widget.post.id, newComment);
    commentTextController.clear();
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }
  // show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDeletePressed?.call();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Profile + Username + Delete
          GestureDetector(
            onTap: () => Navigator.push(
                context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(uid: widget.post.userId)
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: postUser!.profileImageUrl,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                      : const Icon(Icons.person, size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.post.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isOwnPost)
                    IconButton(
                      onPressed: showOptions,
                      icon: const Icon(Icons.delete),
                    ),
                ],
              ),
            ),
          ),

          // Post Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // Like, Comment, Timestamp row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 28,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                Text(widget.post.likes.length.toString()),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: const Icon(Icons.comment, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  widget.post.timestamp.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Post Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Expanded(child: Text(widget.post.text)),
              ],
            ),
          ),

          // Comments Section using CommentTile
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              List<Comment> commentsToShow = [];

              if (state is PostsLoaded) {
                final post = state.posts.firstWhere(
                      (p) => p.id == widget.post.id,
                  orElse: () => widget.post,
                );
                commentsToShow = post.comments;
              } else if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostsError) {
                return Center(child: Text(state.message));
              }

              if (commentsToShow.isEmpty) return const SizedBox();

              return ListView.builder(
                itemCount: commentsToShow.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final comment = commentsToShow[index];
                  return CommentTile(comment: comment);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
