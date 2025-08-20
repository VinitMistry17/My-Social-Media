import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

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
  //text controller
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPwController = TextEditingController();

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
                  //create an account msg
                  Text(
                      "Let's create an account for you!",
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

                  //name text field
                  MyTextField(
                    controller: nameController,
                    hintText: "Enter your name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10,),

                  //pw text field
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter your password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),

                  //confirm pw text field
                  MyTextField(
                    controller: confirmPwController,
                    hintText: "Enter confirm password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25,),

                  //Register button
                  MyButton(
                    onTap: () {},
                    text: "Register",
                  ),
                  const SizedBox(height: 50,),

                  //Already a member ? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member ? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages ,
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
          )
      ),
    );
  }
}
