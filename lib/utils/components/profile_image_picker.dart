import 'package:flutter/material.dart';
import '../Theme/color_theme.dart';


class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          minRadius: 40.0,
          maxRadius: 40.0,
          backgroundColor: kSecondaryColor,
          backgroundImage: NetworkImage(
            'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp',
          ),
        ),
      ],
    );
  }
}
