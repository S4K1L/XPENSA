import 'package:flutter/material.dart';

import '../Theme/color_theme.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final dynamic title;

  const CustomButton({
    super.key,
    required this.onPress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
        ),
        padding: const EdgeInsets.only(right: kDefaultPadding),
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kSecondaryColor, kPrimaryColor],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: kTextWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}