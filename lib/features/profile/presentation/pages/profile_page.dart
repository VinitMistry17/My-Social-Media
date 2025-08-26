import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/profile/presentation/components/bio_box.dart';
import 'package:my_social_media/features/profile/presentation/components/follow_button.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../post/presentation/components/post_tile.dart';
import '../../../post/presentation/cubits/post_cubit.dart';
import '../../../post/presentation/cubits/post_states.dart';
import '../components/profile_status.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';
import 'edit_profile_page.dart';
import 'follower_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  // ✅ Get PostCubit
  late final postCubit = context.read<PostCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();
    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*
    FOLLOW / UNFOLLOW BUTTON
   */

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return; // return if profile is not loaded
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // optimistically update UI
    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      // revert optimistically updated UI
      setState(() {
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        } else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    //is own post
    bool isOwnPost = (currentUser?.uid == widget.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;
          // ✅ A variable to hold the post count, updated inside the BlocBuilder
          int postCount = 0;

          return Scaffold(
            // Appbar
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                //edit profile button

                if(isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
              ],
            ),

            // Body
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // profile pic
                Center(
                  child: CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    // loading..
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    // error failed to load
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    // loaded
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // email (subtle look)
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                //profile status
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, postState) {
                    if (postState is PostsLoaded) {
                      final userPosts = postState.posts.where((post) => post.userId == widget.uid).toList();
                      postCount = userPosts.length;
                    }
                    return ProfileStatus(
                      postCount: postCount,
                      followerCount: user.followers.length,
                      followingCount: user.following.length,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowerPage(
                            followers: user.followers,
                            following: user.following,
                          ),
                        ),
                      ),
                    );
                  },
                ),


                const SizedBox(height: 25),


                //follow button
                if(!isOwnPost)
                  FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: user.followers.contains(currentUser!.uid),
                  ),

                const SizedBox(height: 25),

                // bio section
                Text(
                  "Bio",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                BioBox(text: user.bio),

                const SizedBox(height: 25),

                // posts section
                Text(
                  "Posts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),

                // list of posts from this user
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    // post loaded..
                    if (state is PostsLoaded) {
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      // ✅ postCount should be updated here to reflect the number of posts
                      postCount = userPosts.length;

                      return ListView.builder(
                        itemCount: postCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // get individual posts
                          final post = userPosts[index];

                          // return as post tile UI
                          return PostTile(
                            post: post,
                            onDeletePressed: () {
                              // ✅ Pass profileCubit and userId to the deletePost method
                              context.read<PostCubit>().deletePost(
                                  post.id,
                                  post.userId,
                                  context.read<ProfileCubit>()
                              );
                            },
                          );
                        },
                      );
                    }

                    // post loading..
                    else if (state is PostsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: Text("No posts found.."),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }

        // loading
        else if (state is ProfileLoading) {
          return const ConstrainedScaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Center(
            child: Text("No profile found.."),
          );
        }
      },
    );
  }
}