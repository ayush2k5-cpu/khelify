// 1. Dart/Flutter SDK
import 'package:flutter/material.dart';

// 2. External packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 3. App imports — core first
import 'package:khelify_app/core/models/user_model.dart';
import 'package:khelify_app/core/theme/app_colors.dart';
import 'package:khelify_app/core/theme/app_typography.dart';
import 'package:khelify_app/features/auth/providers/auth_provider.dart';

// 4. Relative imports — same feature
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedSport;
  bool _isSaving = false;

  final List<String> _sports = ['football', 'badminton', 'cricket'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _selectedSport = widget.user.sport;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Avatar Picker ─────────────────────────────────────

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    final authUser = ref.read(currentUserProvider);
    if (authUser == null) return;

    setState(() => _isSaving = true);
    await ref.read(profileProvider.notifier).updateAvatar(authUser.uid, image);
    setState(() => _isSaving = false);
  }

  // ── Save Profile ──────────────────────────────────────

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authUser = ref.read(currentUserProvider);
    if (authUser == null) return;

    setState(() => _isSaving = true);

    await ref.read(profileProvider.notifier).updateProfile(
          uid: authUser.uid,
          displayName: _nameController.text.trim(),
          sport: _selectedSport,
        );

    setState(() => _isSaving = false);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final avatarUrl = profileState is ProfileLoaded
        ? profileState.user.avatarUrl
        : widget.user.avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTypography.h3),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Avatar Picker ───────────────────────
              GestureDetector(
                onTap: _isSaving ? null : _pickAvatar,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.surface,
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl == null
                          ? const Icon(Icons.person,
                              size: 55, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                      ),
                    ),
                    if (_isSaving)
                      const Positioned.fill(
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Tap to change photo', style: AppTypography.bodySmall),
              const SizedBox(height: 32),

              // ── Display Name ────────────────────────
              TextFormField(
                controller: _nameController,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: AppTypography.bodySmall,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      const Icon(Icons.person_outline, color: Colors.white54),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Display name cannot be empty';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Sport Dropdown ──────────────────────
              DropdownButtonFormField<String>(
                initialValue: _selectedSport,
                dropdownColor: AppColors.surface,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Sport',
                  labelStyle: AppTypography.bodySmall,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.sports, color: Colors.white54),
                ),
                items: _sports
                    .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(
                            sport[0].toUpperCase() + sport.substring(1),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSport = value);
                  }
                },
              ),
              const SizedBox(height: 40),

              // ── Save Button ─────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Save Changes', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
