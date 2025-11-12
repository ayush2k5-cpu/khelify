import '../models/post.dart';

// ══════════════════════════════════════════════════════════
// MOCK DATA SERVICE
// Sample posts for demo/testing
// Replace with Firestore in production
// ══════════════════════════════════════════════════════════

class MockDataService {
  
  // ========== SAMPLE POSTS ==========
  
  static List<Post> getMockPosts() {
    return [
      // Post 1: Elite athlete with video
      Post(
        id: '1',
        userId: 'user_1',
        userName: 'Sarah Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        userTier: 'Elite',
        content: 'Crushed my 40m sprint today! 🔥\nNew PR: 5.9s (-0.4s improvement)\nFeeling unstoppable! 💪',
        mediaUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        mediaThumbnail: 'https://picsum.photos/400/300?random=1',
        mediaType: 'video',
        mediaDuration: 15,
        drillName: '40m Sprint',
        drillIcon: '⚡',
        score: 87,
        tier: 'ELITE',
        likes: 124,
        comments: 18,
        reposts: 7,
        shares: 3,
        likedBy: [],
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isVerified: true,
      ),
      
      // Post 2: Pro athlete achievement
      Post(
        id: '2',
        userId: 'user_2',
        userName: 'Rajesh Kumar',
        userAvatar: 'https://i.pravatar.cc/150?img=12',
        userTier: 'Pro',
        content: 'Just unlocked the Speed Demon badge! 🏆\nConsistency is key. 6 weeks of training paying off! 🎯',
        mediaUrl: null,
        mediaThumbnail: null,
        mediaType: 'achievement',
        mediaDuration: 0,
        drillName: 'T-Drill Agility',
        drillIcon: '🎯',
        score: 82,
        tier: 'PRO',
        likes: 89,
        comments: 12,
        reposts: 4,
        shares: 2,
        likedBy: [],
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isVerified: false,
      ),
      
      // Post 3: Advanced athlete with image
      Post(
        id: '3',
        userId: 'user_3',
        userName: 'Priya Sharma',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        userTier: 'Advanced',
        content: 'Badminton shadow footwork drill complete! 🏸\nWorking on my court coverage. Tips welcome! 🙏',
        mediaUrl: 'https://picsum.photos/400/300?random=2',
        mediaThumbnail: 'https://picsum.photos/400/300?random=2',
        mediaType: 'image',
        mediaDuration: 0,
        drillName: 'Shadow Footwork',
        drillIcon: '👟',
        score: 75,
        tier: 'ADVANCED',
        likes: 67,
        comments: 9,
        reposts: 2,
        shares: 1,
        likedBy: [],
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isVerified: false,
      ),
      
      // Post 4: Beginner athlete
      Post(
        id: '4',
        userId: 'user_4',
        userName: 'Arjun Patel',
        userAvatar: 'https://i.pravatar.cc/150?img=8',
        userTier: 'Beginner',
        content: 'First time doing cone dribble drill! ⚽\nLoving the KHELIFY community! Let\'s grow together! 💙',
        mediaUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        mediaThumbnail: 'https://picsum.photos/400/300?random=3',
        mediaType: 'video',
        mediaDuration: 20,
        drillName: 'Cone Dribble',
        drillIcon: '⚽',
        score: 58,
        tier: 'BEGINNER',
        likes: 45,
        comments: 15,
        reposts: 1,
        shares: 0,
        likedBy: [],
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        isVerified: false,
      ),
    ];
  }
  
  // ========== SAMPLE DRILLS ==========
  
  static List<Drill> getSportsDrills() {
    return [
      // Football drills
      Drill(
        id: 'football_1',
        name: '40m Sprint',
        icon: '⚡',
        sport: 'Football',
        category: 'Sports',
        description: 'Measure your explosive speed over 40 meters',
        instructions: [
          'Mark a 40m distance',
          'Start from standing position',
          'Sprint at maximum speed',
          'Camera captures full run',
        ],
        estimatedDuration: 30,
        difficulty: 'Easy',
      ),
      Drill(
        id: 'football_2',
        name: 'T-Drill',
        icon: '🎯',
        sport: 'Football',
        category: 'Sports',
        description: 'Test agility and change of direction',
        instructions: [
          'Set up T-shape cone pattern',
          'Sprint forward, shuffle left/right',
          'Backpedal to start',
          'Focus on sharp cuts',
        ],
        estimatedDuration: 45,
        difficulty: 'Medium',
      ),
      Drill(
        id: 'football_3',
        name: 'Cone Dribble',
        icon: '⚽',
        sport: 'Football',
        category: 'Sports',
        description: 'Dribble through cones testing ball control',
        instructions: [
          'Place 8 cones in a line',
          'Dribble through zigzag pattern',
          'Use both feet',
          'Maintain close ball control',
        ],
        estimatedDuration: 60,
        difficulty: 'Medium',
      ),
      
      // Badminton drills
      Drill(
        id: 'badminton_1',
        name: '40m Sprint',
        icon: '⚡',
        sport: 'Badminton',
        category: 'Sports',
        description: 'Speed test for badminton athletes',
        instructions: [
          'Mark a 40m distance',
          'Start from standing position',
          'Sprint at maximum speed',
          'Camera captures full run',
        ],
        estimatedDuration: 30,
        difficulty: 'Easy',
      ),
      Drill(
        id: 'badminton_2',
        name: 'T-Drill',
        icon: '🎯',
        sport: 'Badminton',
        category: 'Sports',
        description: 'Agility drill for court movement',
        instructions: [
          'Set up T-shape pattern',
          'Simulate court coverage',
          'Quick directional changes',
          'Focus on footwork',
        ],
        estimatedDuration: 45,
        difficulty: 'Medium',
      ),
      Drill(
        id: 'badminton_3',
        name: 'Shadow Footwork',
        icon: '👟',
        sport: 'Badminton',
        category: 'Sports',
        description: 'Practice court movement patterns',
        instructions: [
          'Start at center court position',
          'Shadow movements to all corners',
          'Return to center each time',
          'Maintain proper stance',
        ],
        estimatedDuration: 90,
        difficulty: 'Hard',
      ),
    ];
  }
  
  static List<Drill> getEsportsDrills() {
    return [
      // Coming soon placeholder
      Drill(
        id: 'esports_placeholder',
        name: 'Coming Soon',
        icon: '🎮',
        sport: 'Esports',
        category: 'Esports',
        description: 'Esports drills launching soon!',
        instructions: ['Stay tuned for updates'],
        estimatedDuration: 0,
        difficulty: 'Easy',
      ),
    ];
  }
  
  // ========== HELPER: Get drills by sport ==========
  
  static List<Drill> getDrillsBySport(String sport) {
    return getSportsDrills()
        .where((drill) => drill.sport == sport)
        .toList();
  }
  
  // ========== HELPER: Get drill by ID ==========
  
  static Drill? getDrillById(String id) {
    try {
      return getSportsDrills().firstWhere((drill) => drill.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // ========== CURRENT USER (Mock) ==========
  
  static AppUser getCurrentUser() {
    return AppUser(
      id: 'current_user',
      name: 'You',
      email: 'you@khelify.app',
      avatar: 'https://i.pravatar.cc/150?img=20',
      role: 'Athlete',
      tier: 'Pro',
      totalScore: 340,
      totalPosts: 12,
      followers: 89,
      following: 45,
      joinedAt: DateTime.now().subtract(Duration(days: 60)),
    );
  }
}