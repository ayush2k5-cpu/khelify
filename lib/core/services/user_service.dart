import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Service for user profile CRUD operations in Firestore.
/// Shared across features — Profile, Feed, Stats all read user data.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collection = 'users';

  /// Get a user by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw 'Failed to fetch user: $e';
    }
  }

  /// Stream a user's data (for real-time updates)
  Stream<UserModel?> streamUser(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  /// Create a new user document (call after signup)
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.uid)
          .set(user.toFirestore());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  /// Update an existing user document
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.uid)
          .update(user.copyWith(updatedAt: DateTime.now()).toFirestore());
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  /// Update specific fields only (for incremental updates like drill count)
  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      fields['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore.collection(_collection).doc(uid).update(fields);
    } catch (e) {
      throw 'Failed to update user fields: $e';
    }
  }

  /// Increment total drill count and update best/average scores after a drill
  Future<void> recordDrillCompletion({
    required String uid,
    required double score,
  }) async {
    try {
      final user = await getUser(uid);
      if (user == null) return;

      final newTotal = user.totalDrills + 1;
      final newBest = score > user.bestScore ? score : user.bestScore;
      // Running average: ((old_avg * old_count) + new_score) / new_count
      final newAvg =
          ((user.averageScore * user.totalDrills) + score) / newTotal;

      // Determine tier from best score
      String newTier;
      if (newBest >= 90) {
        newTier = 'elite';
      } else if (newBest >= 75) {
        newTier = 'pro';
      } else if (newBest >= 60) {
        newTier = 'advanced';
      } else {
        newTier = 'beginner';
      }

      await updateUserFields(uid, {
        'totalDrills': newTotal,
        'bestScore': newBest,
        'averageScore': newAvg,
        'tier': newTier,
      });
    } catch (e) {
      throw 'Failed to record drill completion: $e';
    }
  }

  /// Delete a user document
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}
