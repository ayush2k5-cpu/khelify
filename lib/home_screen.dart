import 'package:flutter/material.dart';
import 'package:khelify_app/services/auth_service.dart'; // Import your auth service

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white, // <<< This forces pure white background!
      appBar: AppBar(
        backgroundColor: Colors.white, // <<< AppBar also white
        foregroundColor: Colors.black,
        title: const Text(
          'Khelify Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              authService.signOut();
            },
          )
        ],
        elevation: 0.5,
      ),
      body: const Center(
        child: Text(
          'Welcome! You are logged in.',
          style: TextStyle(fontSize: 20, color: Colors.black), // <<< Dark text for light bg
        ),
      ),
    );
  }
}
