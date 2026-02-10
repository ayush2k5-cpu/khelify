import 'package:flutter/material.dart';
import '../features/auth/screens/auth_gate.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/drill/screens/drill_selection_screen.dart';
import '../features/drill/screens/drill_recording_screen.dart';
import '../features/drill/screens/drill_results_screen.dart';
import '../features/drill/models/drill.dart';
import '../features/drill/services/scoring_service.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthGate());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case '/drill/select':
        return MaterialPageRoute(builder: (_) => const DrillSelectionScreen());

      case '/drill/record':
        final drill = settings.arguments as Drill;
        return MaterialPageRoute(
          builder: (_) => DrillRecordingScreen(drill: drill),
        );

      case '/drill/results':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DrillResultsScreen(
            drill: args['drill'] as Drill,
            scoringResult: args['scoringResult'] as ScoringResult,
            durationSeconds: args['duration'] as int,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
