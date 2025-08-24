import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../post/domain/entities/post.dart';
import '../../../post/presentation/cubits/post_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post; // Post entity
  final void Function()? onDeletePressed; // Callback for delete

  const PostTile({
    required this.post,
    required this.onDeletePressed,
    super.key,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnPost = false; // flag for checking if current user made this post

  // current user
  AppUser? currentUser;

  // user who posted
  ProfileUser? postUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // get current user
    getCurrentUser();

    // fetch profile of post creator
    fetchPostUser();
  }

  // get current logged in user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  // fetch the profile details of post owner
  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // show delete confirmation dialog
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // delete button
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
      margin: const EdgeInsets.symmetric(vertical: 8), // spacing between posts
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= Top Section: Profile + Name + Delete =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Profile Picture
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

                const SizedBox(width: 10), // spacing

                // Username
                Expanded(
                  child: Text(
                    widget.post.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Delete Button (only if own post)
                if (isOwnPost)
                  IconButton(
                    onPressed: showOptions,
                    icon: const Icon(Icons.delete),
                  ),
              ],
            ),
          ),

          // ================= Post Image =================
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

          //button -> like , comment , timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Like Button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
                Text('0'),
                //comment button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment),
                ),
                Text('0'),

                const Spacer(),

                //timestamp
                Text(widget.post.timestamp.toString())

              ],
            ),
          )
        ],
      ),
    );
  }
}
