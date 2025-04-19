import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easygarden/components/my_button.dart';
import 'package:easygarden/components/my_textfield.dart';
import 'package:easygarden/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // loading state
  bool isLoading = false;

  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // login method
  void registerUser() async {
    // validate inputs
    if (!_formKey.currentState!.validate()) return;

    // check if passwords match
    if (passwordController.text != confirmPwController.text) {
      // show error message to user
      displayMessageToUser("Passwords don't match!", context);
    }
    
    // start loading
    setState(() => isLoading = true);

    try {
      // create the user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      // create a user document and add to firestore
      await createUserDocument(userCredential);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    } on FirebaseAuthException catch (e) {
      // display error message to user
      displayMessageToUser(e.message ?? "Registration failed", context);
    } finally {
      // stop loading
      if (mounted) setState(() => isLoading = false);
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                // app name
                Text("Easy Garden", style: TextStyle(fontSize: 20)),

                const SizedBox(height: 50),

                // username textfield
                MyTextfield(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required";
                    } else if (value.length < 3) {
                      return "Username must be at least 3 characters";
                    } else if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value)) {
                      return "Username can only contain letters, numbers, and underscores";
                    }
                    return null;
                  }
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  }
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "Password must contain at least one number";
                    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return "Password must contain at least one special character";
                    }
                    return null;
                  }
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    } else if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  }
                ),

                const SizedBox(height: 10),

                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // register button
                MyButton(text: "Register", onTap: registerUser),

                const SizedBox(height: 25),

                // don't have an account? Register here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}