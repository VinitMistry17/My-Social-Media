import 'package:flutter/material.dart';

import '../../domain/entities/profile_user.dart';
import '../pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;

  const UserTile({
    required this.user,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfilePage(uid: user.uid),
          ),
        );
      }
    );
  }
}
