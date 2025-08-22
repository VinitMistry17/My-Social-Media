import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  //final String uid;
  const ProfilePage({
    super.key,
    //required this.uid
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();

  //current user
  late AppUser? currentUser = authCubit.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser!.email),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
    );
  }
}
