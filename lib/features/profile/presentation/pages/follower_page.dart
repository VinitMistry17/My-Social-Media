/*
   This page will display a tab bar to show

   - List of followers
   - List of following
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_social_media/features/profile/presentation/pages/profile_page.dart';

import '../cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // App Bar
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          title: const Text(
            "Connections",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),

        // Tab Bar View
        body: TabBarView(
          children: [
            _buildUserList(followers, "No followers yet 💔", context),
            _buildUserList(following, "Not following anyone 🙈", context),
          ],
        ),
      ),
    );
  }
}

// build user list , build a list of profile uids
Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
    ) {
  return uids.isEmpty
      ? Center(
    child: Text(
      emptyMessage,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    ),
  )
      : ListView.builder(
    itemCount: uids.length,
    itemBuilder: (context, index) {
      final uid = uids[index];

      return FutureBuilder(
        future: context.read<ProfileCubit>().getUserProfile(uid),
        builder: (context, snapshot) {
          // loading..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Loading..."),
            );
          }

          // error / not found
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == null) {
            return const ListTile(
              leading: CircleAvatar(child: Icon(Icons.error)),
              title: Text("User not found.."),
            );
          }

          // user loaded
          final user = snapshot.data!;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                user.profileImageUrl,
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              user.email,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),

            onTap: () => Navigator.push(
                context,
              MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid)),
            )
          );
        },
      );
    },
  );
}
