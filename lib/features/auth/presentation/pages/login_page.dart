import 'package:flutter/material.dart';
import 'package:my_social_media/features/auth/presentation/components/my_text_field.dart';

import '../components/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final pwController = TextEditingController();

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
                    onTap: () {},
                    text: "Login",
                  ),
                  const SizedBox(height: 50,),
                  //not a member ? register now
                  Text(
                      "Not a member? Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
