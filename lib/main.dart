import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//just practicing git/github

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(),
    );
  }
}