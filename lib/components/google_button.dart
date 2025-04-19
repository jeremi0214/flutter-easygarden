import 'package:flutter/material.dart';
import 'package:easygarden/services/google_auth_service.dart';
import 'package:easygarden/helper/helper_functions.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => _isLoading = true);
        final user = await GoogleAuthService().signInWithGoogle();
        setState(() => _isLoading = false);

        // sign in failed
        if (user == null && context.mounted) {
          displayMessageToUser("Google sign-in failed", context);
        } 

        // sign in successfully
        else if (user != null && context.mounted) {
          Navigator.pushReplacementNamed(context, '/home_page');
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
            if (_isLoading)
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else ...[
              Image.asset('assets/google_logo.png', height: 24),
              const SizedBox(width: 10),
              const Text("Sign in with Google", style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}