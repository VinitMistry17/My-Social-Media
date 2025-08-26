/*
   This page will display a tab bar to show

   - List of followers
   - List of following
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_social_media/features/profile/presentation/components/user_tile.dart';
import 'package:my_social_media/features/profile/presentation/pages/profile_page.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

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
      child: ConstrainedScaffold(
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
          //user loaded
          if(snapshot.hasData){
            final user = snapshot.data!;
            return UserTile(user: user);
          }

          //loading
          else if(snapshot.connectionState == ConnectionState.waiting){
            return ListTile(title: Text("Loading..."));
          }

          //not found
          else{
            return ListTile(title: Text("User not found"));
          }
        },
      );
    },
  );
}
