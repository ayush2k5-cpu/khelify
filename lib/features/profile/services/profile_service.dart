// 1. Dart/Flutter SDK
import 'dart:io';

// 2. External packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads avatar image to Firebase Storage and returns the download URL
  Future<String> uploadAvatar(String uid, XFile image) async {
    try {
      final ref = _storage.ref().child('avatars').child('$uid.jpg');

      final uploadTask = await ref.putFile(File(image.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload avatar: $e';
    }
  }
}
