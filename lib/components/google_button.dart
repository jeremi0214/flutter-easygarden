import 'package:flutter/material.dart';
import 'package:easygarden/services/google_auth_service.dart';
import 'package:easygarden/helper/helper_functions.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final user = await GoogleAuthService().signInWithGoogle();
        if (user == null && context.mounted) {
          displayMessageToUser("Google sign-in failed", context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/google_logo.png',
              height: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              "Sign in with Google",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}