import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

/// Provider for the UserService instance
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// Stream provider for the current user's profile data
/// Automatically updates when Firestore data changes
final currentUserProfileProvider = StreamProvider<UserModel?>((ref) {
  final authUser = ref.watch(currentUserProvider);
  if (authUser == null) return Stream.value(null);

  final userService = ref.watch(userServiceProvider);
  return userService.streamUser(authUser.uid);
});

/// One-time fetch of a specific user by UID (for feed cards, etc.)
final userByIdProvider =
    FutureProvider.family<UserModel?, String>((ref, uid) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUser(uid);
});
