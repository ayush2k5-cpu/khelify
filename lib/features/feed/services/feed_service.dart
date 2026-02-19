// 1. Dart/Flutter SDK
// 2. External packages
import 'package:cloud_firestore/cloud_firestore.dart';

// 4. Relative imports (same feature)
import '../models/feed_post.dart';

class FeedService {
  final _firestore = FirebaseFirestore.instance;

  // Returns a stream of feed posts, sorted by newest first
  Stream<List<FeedPost>> getFeedStream() {
    return _firestore
        .collection('feed')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FeedPost.fromFirestore(doc)).toList());
  }
}
