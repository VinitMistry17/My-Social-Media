import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../responsive/constrained_scaffold.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../post/domain/entities/post.dart';
import '../../../post/presentation/cubits/post_cubit.dart';
import '../../../post/presentation/cubits/post_states.dart';
import '../../../post/presentation/pages/upload_post_page.dart';
import '../components/my_drawer.dart';
import '../../../post/presentation/components/post_tile.dart';
// ✅ Import ProfileCubit
import 'package:my_social_media/features/profile/presentation/cubits/profile_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Get postCubit from context
  late final postCubit = context.read<PostCubit>();
  // ✅ Get ProfileCubit from context
  late final profileCubit = context.read<ProfileCubit>();
  // ✅ Get AuthCubit from context
  late final authCubit = context.read<AuthCubit>();


  // On widget start
  @override
  void initState() {
    super.initState();

    // fetch posts from firebase
    fetchAllPosts();
  }

  // function to fetch all posts
  void fetchAllPosts() async {
    await postCubit.fetchAllPosts();
  }

  // function to delete a post
  void deletePost(String postId) async {
    // ✅ Pass the current user's UID and ProfileCubit to the deletePost method
    await postCubit.deletePost(postId, authCubit.currentUser!.uid, profileCubit);
    fetchAllPosts(); // refresh list after delete
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          // upload new post button (+)
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ),
            icon: const Icon(Icons.add, size: 40),
          ),
        ],
      ),

      // Drawer (side menu)
      drawer: const MyDrawer(),

      // BODY with BlocBuilder
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // default empty list of posts
          List<Post> allPosts = [];

          // ---------------- STATE HANDLING ----------------

          // loading OR uploading state
          if (state is PostsLoading || state is PostsUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // posts loaded
          else if (state is PostsLoaded) {
            allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No posts found"),
              );
            }
          }

          // error state
          else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          }else {
            return const SizedBox();
          }

          // ------------------------------------------------

          // show all posts in ListView
          return ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              final post = allPosts[index];

              return PostTile(
                post: post,
                onDeletePressed: () =>  deletePost(post.id),
              );
            },
          );
        },
      ),
    );
  }
}
