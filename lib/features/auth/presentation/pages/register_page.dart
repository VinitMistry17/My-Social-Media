import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPwController = TextEditingController();

  void register() {
    final String email = emailController.text;
    final String pw = pwController.text;
    final String name = nameController.text;
    final String confirmPw = confirmPwController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && pw.isNotEmpty && name.isNotEmpty && confirmPw.isNotEmpty) {
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords don't match"),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(   // 👈 ab center ho gaya
          child: SingleChildScrollView(   // 👈 scroll bhi milega small screens ke liye
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 👈 login page jaisa
                children: [
                  //logo
                  Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50,),

                  //create account msg
                  Text(
                    "Let's create an account for you!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 25,),

                  //name field
                  MyTextField(
                    controller: nameController,
                    hintText: "Enter your name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10,),

                  //email field
                  MyTextField(
                    controller: emailController,
                    hintText: "Enter your email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10,),

                  //password
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),

                  //confirm pw
                  MyTextField(
                    controller: confirmPwController,
                    hintText: "Enter confirm password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25,),

                  //register button
                  MyButton(
                    onTap: register,
                    text: "Register",
                  ),
                  const SizedBox(height: 50,),

                  //Already a member ? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          "Login now",
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
          ),
        ),
      ),
    );
  }
}