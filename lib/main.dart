import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'themes/app_theme.dart';
import 'screens/auth_gate.dart';  // ADD THIS IMPORT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHELIFY',
      theme: AppTheme.premiumDarkTheme,
      home: AuthGate(),  // CHANGE THIS LINE (was RoleSelectionScreen)
      debugShowCheckedModeBanner: false,
    );
  }
}