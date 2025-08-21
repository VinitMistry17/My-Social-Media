import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/features/auth/presentation/components/my_text_field.dart';

import '../components/my_button.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final Function()? togglePages;
  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  //login button press
  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //ensure that the email and pw files are not empty
    if (email.isNotEmpty && pw.isNotEmpty) {
      //.login , cubit wale login ko call karega , jo auth_cubit.dart me hai
      authCubit.login(email, pw);
    }

    //display errors if some fields are empty..
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password"),
        ),
      );
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50,),
                  //welcome back msg
                  Text(
                      "Welcome back!, you've been missed!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ),

                  //email text field
                  const SizedBox(height: 25,),
                  MyTextField(
                      controller: emailController,
                      hintText: "Enter your email",
                      obscureText: false,
                  ),
                  const SizedBox(height: 10,),

                  //pw text field
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25,),

                  //login button
                  MyButton(
                    onTap: login,
                    text: "Login",
                  ),
                  const SizedBox(height: 50,),
                  //not a member ? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Not a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages ,
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
