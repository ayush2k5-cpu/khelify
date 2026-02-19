import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_post.dart';

final feedStreamProvider = StreamProvider<List<FeedPost>>((ref) {
  return FirebaseFirestore.instance
      .collection('feed')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FeedPost.fromFirestore(doc)).toList());
});
