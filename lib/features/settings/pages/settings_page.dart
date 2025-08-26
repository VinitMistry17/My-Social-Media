/*

    Settings Page:
    - Dark Mode
    - Blocked Users
    - account setting

 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

import '../../../themes/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    //is dark mode
    final isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
    body: Column(
      children: [
        ListTile(
          title: const Text("Dark Mode"),
          trailing: CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) => themeCubit.toggleTheme(),
          ),
        ),
      ],
    ),
    );
  }
}
