import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/auth/data/firebase_auth_repo.dart';
import 'package:my_social_media/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:my_social_media/themes/light_theme.dart';

import 'features/auth/presentation/cubit/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/post/presentation/pages/home_page.dart';

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

* */

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(authRepo : authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightMode,
        //BlocConsumer = listen states
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            //unauthenticated -> auth page (login/register)
            if (authState is Unauthenticated) {
              return const AuthPage();
            }
            //authenticated -> go to home page
            if (authState is Authenticated) {
              return const HomePage();
            }

            //loading -> show loading screen
            else{
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }, listener: (context, state) {
            //error -> show error message
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                )
              );
            }
          },
        )
      ),
    );
  }
}