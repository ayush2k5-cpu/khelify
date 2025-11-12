import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes/khelify_theme.dart';
import 'screens/main_app_screen.dart';

// ══════════════════════════════════════════════════════════
// KHELIFY MAIN APP
// Entry Point
// ══════════════════════════════════════════════════════════

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const KhelifyApp());
}

class KhelifyApp extends StatelessWidget {
  const KhelifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHELIFY',
      debugShowCheckedModeBanner: false,
      theme: KhelifyTheme.darkTheme,
      home: MainAppScreen(),
    );
  }
}
