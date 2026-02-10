import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/drill_result.dart';

/// Provider for saving drill results to Firestore.
final drillResultServiceProvider = Provider((ref) => DrillResultService());

class DrillResultService {
  final _firestore = FirebaseFirestore.instance;

  /// Save a drill result to Firestore.
  Future<String> saveDrillResult(DrillResult result) async {
    final docRef = await _firestore
        .collection('drill_results')
        .add(result.toFirestore());
    return docRef.id;
  }

  /// Get drill results for a user.
  Future<List<DrillResult>> getUserResults(String userId) async {
    final snapshot = await _firestore
        .collection('drill_results')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map(DrillResult.fromFirestore).toList();
  }
}
