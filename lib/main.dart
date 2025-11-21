import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes/khelify_theme.dart';
import 'screens/main_app_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // BLACK ON WHITE
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const KhelifyApp());
}

class KhelifyApp extends StatelessWidget {
  const KhelifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHELIFY',
      debugShowCheckedModeBanner: false,
      theme: KhelifyTheme.lightTheme,
      home: const MainAppScreen(),
      scrollBehavior: NoGlowScrollBehavior(), // Use your custom scroll behavior globally
    );
  }
}

// ========= UTILS =========

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
