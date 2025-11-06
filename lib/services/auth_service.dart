import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Get instances of Firebase Auth and Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- SIGN UP with Email & Password ---
  Future<User?> signUpWithEmail(String email, String password, String username) async {
    // 1. Create the user in Firebase Auth
    // This will now "throw" an error if it fails, which we will catch in the UI.
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Get the new user
    User? newUser = userCredential.user;

    if (newUser != null) {
      // 3. Save the user's extra data to Firestore
      await _firestore.collection('users').doc(newUser.uid).set({
        'username': username,
        'email': email,
        'uid': newUser.uid,
        // Add any other fields you want to save
      });
    }
    return newUser;
  }

  // --- SIGN IN with Email & Password ---
  Future<User?> signInWithEmail(String email, String password) async {
    // We will also let this throw an error to be caught in the login_screen
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- (Optional) Get current user ---
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}