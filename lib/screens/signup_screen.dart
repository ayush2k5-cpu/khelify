import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1419),
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: Color(0xFF1A1F2E),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nameController, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person, color: Color(0xFF5B7EFF)))),
            SizedBox(height: 16),
            TextField(controller: _emailController, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email, color: Color(0xFF5B7EFF)))),
            SizedBox(height: 16),
            TextField(controller: _passwordController, style: TextStyle(color: Colors.white), obscureText: true, decoration: InputDecoration(hintText: 'Password', prefixIcon: Icon(Icons.lock, color: Color(0xFF5B7EFF)))),
            SizedBox(height: 16),
            TextField(controller: _confirmPasswordController, style: TextStyle(color: Colors.white), obscureText: true, decoration: InputDecoration(hintText: 'Confirm Password', prefixIcon: Icon(Icons.lock, color: Color(0xFF5B7EFF)))),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B7EFF)), child: Text('Create Account')),
          ],
        ),
      ),
    );
  }
}
