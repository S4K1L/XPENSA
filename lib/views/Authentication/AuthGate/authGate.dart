import 'package:xpensa/views/Authentication/login.dart';
import 'package:xpensa/views/Bottom_Bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData)
          {
            return const CustomBottomBar();
          }
          else{
            return LoginScreen();
          }
        },
      ),
    );
  }
}