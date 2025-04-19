import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Begin interactive sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    // Get the auth details
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Optional: create Firestore doc if it doesn't exist
    final userDoc = FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email);
    final snapshot = await userDoc.get();
    if (!snapshot.exists) {
      await userDoc.set({
        'email': userCredential.user!.email,
        'username': userCredential.user!.displayName ?? 'Google User',
        'role': 'user', // or prompt role selection later
      });
    }

    return userCredential;
  } catch (e) {
    print("Google Sign-In error: $e");
    return null;
  }
}