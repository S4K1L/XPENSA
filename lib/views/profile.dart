import 'package:xpensa/utils/widgets/profile_user_data.dart';
import 'package:flutter/material.dart';
import '../utils/Theme/color_theme.dart';
import '../utils/components/master_card.dart';
import '../utils/widgets/profile_buttons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTextBlackColor,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/black.png'),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                ProfileUserData(),
                Expanded(
                  child: ProfileButtons(),
                ),
              ],
            ),
          ),
          MasterCard(),
        ],
      ),
    );
  }
}
