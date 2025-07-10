import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/profile_image_picker.dart';

class UserDataContainer extends StatefulWidget {
  const UserDataContainer({super.key});

  @override
  State<UserDataContainer> createState() => _UserDataContainerState();
}

class _UserDataContainerState extends State<UserDataContainer> {
  Map<String, dynamic> userData = {};

  Future<void> getUserData() async {
    try {
      String userUID = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUID)
              .get();
      setState(() {
        userData = userDataSnapshot.data() as Map<String, dynamic>;
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0054FB), Color(0xFF1B1FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileImagePicker(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  userData['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 30,
              ),
              Positioned(
                right: 0,
                top: 2,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
