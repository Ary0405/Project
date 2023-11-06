import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 20, top: 40),
      child: const Text(
        'Swaps',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
