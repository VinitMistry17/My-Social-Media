import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

import '../../../profile/presentation/components/user_tile.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/firebase_search_repo.dart';
import '../cubits/search_cubit.dart';
import '../cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  // ✅ Will access cubit inside build or listener safely
  // late final searchCubit = context.read<SearchCubit>();

  @override
  void initState() {
    super.initState();
    // listener for search
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    context.read<SearchCubit>().searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search User..",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no user
            if (state.users.isEmpty) {
              return const Center(
                child: Text("No user found"),
              );
            }

            // users
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                if (user == null) return const SizedBox(); // ✅ null safety fix
                return UserTile(user: user); // type error fixed
              },
            );
          }

          //loading
          else if(state is SearchLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //error
          else if(state is SearchError){
            return Center(
              child: Text(state.message),
            );
          }

          // default state
          return const Center(
            child: Text("Search for users..."),
          );
        },
      ),
    );
  }
}
