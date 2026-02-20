// 1. Dart/Flutter SDK
import 'dart:async';

// 2. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 3. App imports — core first
import 'package:khelify_app/core/models/user_model.dart';
import 'package:khelify_app/core/providers/user_provider.dart';
import 'package:khelify_app/core/services/user_service.dart';

// 4. Relative imports — same feature
import '../services/profile_service.dart';

// ─── States ───────────────────────────────────────────────

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// ─── Notifier ─────────────────────────────────────────────

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserService _userService;
  final ProfileService _profileService;

  ProfileNotifier(this._userService, this._profileService)
      : super(ProfileLoading());

  /// Load profile from Firestore once
  Future<void> loadProfile(String uid) async {
    state = ProfileLoading();
    try {
      final user = await _userService.getUser(uid);
      if (user == null) {
        state = ProfileError('User not found');
      } else {
        state = ProfileLoaded(user);
      }
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  /// Update display name and/or sport
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? sport,
  }) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    try {
      final updated = current.user.copyWith(
        displayName: displayName,
        sport: sport,
      );
      await _userService.updateUser(updated);
      state = ProfileLoaded(updated);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  /// Pick, upload avatar and save URL to Firestore
  Future<void> updateAvatar(String uid, XFile image) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    try {
      final url = await _profileService.uploadAvatar(uid, image);
      final updated = current.user.copyWith(avatarUrl: url);
      await _userService.updateUser(updated);
      state = ProfileLoaded(updated);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }
}

// ─── Providers ────────────────────────────────────────────

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(
    ref.watch(userServiceProvider),
    ref.watch(profileServiceProvider),
  );
});
