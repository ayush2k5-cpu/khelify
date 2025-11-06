import 'package:flutter/material.dart';
import 'package:khelify_app/services/auth_service.dart'; // Import your auth service

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of your auth service
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Khelify Home'),
        actions: [
          // Add a Logout Button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Call your sign out method
              // The AuthGate will automatically detect the logout
              // and send the user back to the login screen.
              _authService.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome! You are logged in.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}