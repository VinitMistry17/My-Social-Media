/*
  FOLLOW BUTTON (Classic Look)

  - Shows "Follow" if not following
  - Shows "Unfollow" if already following
  - Styled with rounded corners & consistent theme colors
*/

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // button colors
        backgroundColor: isFollowing
            ? Theme.of(context).colorScheme.primary
            : Colors.blue,
        foregroundColor: Colors.white,

        // button shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        // button padding
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

        // text style
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(isFollowing ? "Unfollow" : "Follow"),
    );
  }
}
