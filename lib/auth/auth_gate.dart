import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khelify_app/home_screen.dart'; // This file doesn't exist yet, we'll create it next
import 'package:khelify_app/screens/login_screen.dart'; // This is your login screen

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // This 'stream' listens for any changes in authentication state
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Check if the snapshot is still waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading circle while we check
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Check if the user is logged in (snapshot has data)
          if (snapshot.hasData) {
            // User is logged in! Show the Home Screen.
            return const HomeScreen(); // We will create this file in the next step
          }

          // 3. The user is NOT logged in (snapshot has no data)
          else {
            // Show the Login Screen.
            return LoginScreen();
          }
        },
      ),
    );
  }
}