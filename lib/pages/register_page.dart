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

  // text controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPwController = TextEditingController();

  // login method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // validate inputs
    if (!_formKey.currentState!.validate()) {
      Navigator.pop(context); 
      return;
    }

    // make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // pop the loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords don't match!", context);
    }
    
    // if passwords do match
    else {
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

        // create a user document and add to firestore
        await createUserDocument(userCredential);

        // pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.message ?? "Registration failed", context);
      }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
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
                  validator: (value) => 
                      value == null || value.isEmpty ? "Username is required" : null,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!value.contains("@")) return "Enter a valid email";
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) => 
                      value == null || value.length < 6 ? "Password must be at least 6 characters" : null,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                  validator: (value) => 
                      value != passwordController.text ? "Passwords do not match" : null,
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
