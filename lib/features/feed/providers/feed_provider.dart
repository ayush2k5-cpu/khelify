import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_post.dart';

final feedStreamProvider = StreamProvider<List<FeedPost>>((ref) {
  // MOCK DATA FOR DEMO PURPOSES
  return Stream.value([
    FeedPost(
      id: 'mock1',
      userId: 'u1',
      userName: 'Rahul Sharma',
      drillName: 'Sprint Knee Drive',
      score: 92.5,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      sportType: 'athletics',
    ),
    FeedPost(
      id: 'mock2',
      userId: 'u2',
      userName: 'Priya Patel',
      drillName: 'Cover Drive',
      score: 88.0,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      sportType: 'cricket',
    ),
    FeedPost(
      id: 'mock3',
      userId: 'u3',
      userName: 'Amit Singh',
      drillName: 'Instep Kick',
      score: 75.0,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      sportType: 'football',
    ),
    FeedPost(
      id: 'mock4',
      userId: 'u4',
      userName: 'Neha Gupta',
      drillName: 'Fast Bowling Action',
      score: 95.0,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      sportType: 'cricket',
    ),
    FeedPost(
      id: 'mock5',
      userId: 'u5',
      userName: 'Vikram Reddy',
      drillName: 'Change of Direction',
      score: 82.5,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      sportType: 'football',
    ),
  ]);
});
