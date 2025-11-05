import 'package:flutter/material.dart';

// --- NEW IMPORTS (We'll use these) ---
import 'package:firebase_core/firebase_core.dart';
import 'package:khelify_app/auth/auth_gate.dart'; // We will create this file in a later step
import 'package:khelify_app/firebase_options.dart';
// --- END NEW IMPORTS ---

// 'main' must be 'async' to use 'await'
void main() async {
  // --- NEW LINES ---
  // 1. You MUST add this line to ensure Flutter is ready.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. This is the line that connects to Firebase
  // It waits until Firebase is ready before running the app.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // --- END NEW LINES ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khelify',
      theme: ThemeData(primarySwatch: Colors.blue),

      // --- THIS IS THE IMPORTANT CHANGE ---
      // We are changing 'home: LoginScreen()' to 'home: AuthGate()'.
      // This AuthGate will be the new "front door" of your app.
      home: const AuthGate(),
      // --- END OF CHANGE ---

      debugShowCheckedModeBanner: false,
    );
  }
}