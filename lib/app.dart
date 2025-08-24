import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/auth/data/firebase_auth_repo.dart';
import 'package:my_social_media/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:my_social_media/themes/light_theme.dart';

import 'features/auth/presentation/cubit/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/post/data/firebase_post_repo.dart';
import 'features/post/presentation/cubits/post_cubit.dart';
import 'features/profile/data/firebase_profile_repo.dart';
import 'features/profile/presentation/cubits/profile_cubit.dart';
import 'features/storage/data/cloudinary_storage_repo.dart';

/*
App = Root Level

Repositories: for the database
- Firebase

Bloc provider for the state management:
- auth
- profile
- post
- search
- theme

check auth state:
- unauthenticated : auth page (login/register)
- authenticated : go to home page
*/

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();

  // profile repo
  final profileRepo = FirebaseProfileRepo();

  // storage repo
  final storageRepo = CloudinaryStorageRepo();

  // post repo
  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider(
          create: (context) => ProfileCubit(
            storageRepo: storageRepo,
            profileRepo: profileRepo,
          ),
        ),

        // ✅ post cubit
        BlocProvider(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: storageRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightMode,
        // BlocConsumer = listen states
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            // unauthenticated -> auth page (login/register)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }
            // authenticated -> go to home page
            if (authState is Authenticated) {
              return const HomePage();
            }
            // loading -> show loading screen
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            // error -> show error message
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
