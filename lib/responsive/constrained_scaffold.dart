/*

    CONSTRAINED SCAFFOLD:

    this is a normal scaffold but the width of the scaffold is constrained so that,
    it behaves consistently on larger screen (particularly for the web browsers)

 */

import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;

  const ConstrainedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: body,
      ),
    );
  }
}
