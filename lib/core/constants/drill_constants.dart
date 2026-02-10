import '../../features/drill/models/drill.dart';

/// All available drills in v1 of Khelify.
class DrillConstants {
  static const List<String> sports = ['Football', 'Badminton', 'Athletics'];

  static final List<Drill> allDrills = [
    // ─── Football ───
    Drill(
      id: 'fb_sprint_40m',
      name: '40m Sprint',
      sport: 'Football',
      category: 'Speed',
      description: 'Full-speed 40-meter sprint to test acceleration and top speed.',
      instructions: [
        'Stand at the start line in a sprinter stance',
        'Sprint at maximum effort for 40 meters',
        'Focus on knee drive and arm swing',
        'Maintain forward lean during acceleration',
      ],
      estimatedDuration: Duration(seconds: 15),
      difficulty: 'intermediate',
      icon: '🏃',
      scoringCriteria: [
        ScoringCriterion(name: 'Knee Drive', description: 'Hip-knee angle during stride', weight: 0.30, metricType: 'angle'),
        ScoringCriterion(name: 'Arm Swing', description: 'Coordinated arm movement', weight: 0.25, metricType: 'form'),
        ScoringCriterion(name: 'Forward Lean', description: 'Torso angle during acceleration', weight: 0.20, metricType: 'angle'),
        ScoringCriterion(name: 'Stride Consistency', description: 'Regularity of stride length', weight: 0.25, metricType: 'consistency'),
      ],
    ),
    Drill(
      id: 'fb_agility',
      name: 'Agility Ladder',
      sport: 'Football',
      category: 'Agility',
      description: 'Quick footwork through an agility ladder pattern.',
      instructions: [
        'Face the agility ladder',
        'Run through with quick, precise foot placement',
        'Keep your center of gravity low',
        'Pump your arms for balance',
      ],
      estimatedDuration: Duration(seconds: 20),
      difficulty: 'intermediate',
      icon: '⚡',
      scoringCriteria: [
        ScoringCriterion(name: 'Foot Speed', description: 'Ankle movement frequency', weight: 0.35, metricType: 'speed'),
        ScoringCriterion(name: 'Body Control', description: 'Center of mass stability', weight: 0.30, metricType: 'form'),
        ScoringCriterion(name: 'Arm Balance', description: 'Arm coordination during movement', weight: 0.15, metricType: 'form'),
        ScoringCriterion(name: 'Consistency', description: 'Uniform step pattern', weight: 0.20, metricType: 'consistency'),
      ],
    ),
    Drill(
      id: 'fb_ball_control',
      name: 'Ball Control',
      sport: 'Football',
      category: 'Skill',
      description: 'Keep the ball under control with quick touches.',
      instructions: [
        'Stand with the ball at your feet',
        'Perform quick toe taps and sole rolls',
        'Keep your body balanced over the ball',
        'Use both feet equally',
      ],
      estimatedDuration: Duration(seconds: 30),
      difficulty: 'beginner',
      icon: '⚽',
      scoringCriteria: [
        ScoringCriterion(name: 'Body Balance', description: 'Upper body stability during touches', weight: 0.30, metricType: 'form'),
        ScoringCriterion(name: 'Knee Position', description: 'Knee bend and control', weight: 0.25, metricType: 'angle'),
        ScoringCriterion(name: 'Symmetry', description: 'Equal use of both sides', weight: 0.20, metricType: 'consistency'),
        ScoringCriterion(name: 'Posture', description: 'Overall form and posture', weight: 0.25, metricType: 'form'),
      ],
    ),

    // ─── Badminton ───
    Drill(
      id: 'bd_footwork',
      name: 'Court Footwork',
      sport: 'Badminton',
      category: 'Agility',
      description: 'Practice 4-corner court movement patterns.',
      instructions: [
        'Start at the center of the court',
        'Move to each corner with quick steps',
        'Return to center after each corner',
        'Focus on split-step timing',
      ],
      estimatedDuration: Duration(seconds: 30),
      difficulty: 'intermediate',
      icon: '🏸',
      scoringCriteria: [
        ScoringCriterion(name: 'Split Step', description: 'Timing and form of split step', weight: 0.30, metricType: 'form'),
        ScoringCriterion(name: 'Lunge Depth', description: 'Knee angle during lunges', weight: 0.25, metricType: 'angle'),
        ScoringCriterion(name: 'Recovery Speed', description: 'Speed returning to center', weight: 0.25, metricType: 'speed'),
        ScoringCriterion(name: 'Balance', description: 'Stability during movement', weight: 0.20, metricType: 'form'),
      ],
    ),
    Drill(
      id: 'bd_smash',
      name: 'Smash Practice',
      sport: 'Badminton',
      category: 'Power',
      description: 'Overhead smash technique and power.',
      instructions: [
        'Position yourself for an overhead shot',
        'Rotate your torso and extend your arm',
        'Snap your wrist at the point of contact',
        'Follow through fully after the shot',
      ],
      estimatedDuration: Duration(seconds: 20),
      difficulty: 'advanced',
      icon: '💥',
      scoringCriteria: [
        ScoringCriterion(name: 'Arm Extension', description: 'Full arm reach at contact', weight: 0.30, metricType: 'angle'),
        ScoringCriterion(name: 'Torso Rotation', description: 'Hip-shoulder rotation', weight: 0.25, metricType: 'angle'),
        ScoringCriterion(name: 'Follow Through', description: 'Arm path after contact', weight: 0.20, metricType: 'form'),
        ScoringCriterion(name: 'Footwork', description: 'Base foot positioning', weight: 0.25, metricType: 'form'),
      ],
    ),

    // ─── Athletics ───
    Drill(
      id: 'ath_sprint_100m',
      name: '100m Sprint',
      sport: 'Athletics',
      category: 'Speed',
      description: 'Full 100-meter sprint with proper form.',
      instructions: [
        'Start from a crouched position',
        'Drive out with powerful knee lifts',
        'Transition to upright sprinting form',
        'Maintain form through the finish',
      ],
      estimatedDuration: Duration(seconds: 20),
      difficulty: 'advanced',
      icon: '🏅',
      scoringCriteria: [
        ScoringCriterion(name: 'Drive Phase', description: 'Initial acceleration posture', weight: 0.25, metricType: 'angle'),
        ScoringCriterion(name: 'Knee Lift', description: 'Height of knee drive', weight: 0.25, metricType: 'angle'),
        ScoringCriterion(name: 'Arm Mechanics', description: 'Arm swing form and timing', weight: 0.25, metricType: 'form'),
        ScoringCriterion(name: 'Stride Length', description: 'Consistent, optimal stride', weight: 0.25, metricType: 'consistency'),
      ],
    ),
  ];

  /// Get drills by sport
  static List<Drill> getDrillsBySport(String sport) {
    return allDrills.where((d) => d.sport == sport).toList();
  }

  /// Get a single drill by ID
  static Drill? getDrillById(String id) {
    try {
      return allDrills.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
