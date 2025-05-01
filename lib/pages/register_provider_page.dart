import 'package:easygarden/components/my_button.dart';
import 'package:easygarden/components/my_textfield.dart';
import 'package:easygarden/database/firestore.dart';
import 'package:easygarden/helper/helper_functions.dart';
import 'package:easygarden/pages/providers_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterGardenerPage extends StatefulWidget {
  const RegisterGardenerPage({super.key});

  @override
  State<RegisterGardenerPage> createState() => _RegisterGardenerPageState();
}

class _RegisterGardenerPageState extends State<RegisterGardenerPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // Categories
  final List<String> allCategories = [
    "Lawn Care",
    "Tree Pruning",
    "Hedge Trimming",
    "Weeding",
    "Landscaping",
    "Composting",
    "Watering Systems",
    "Garden Cleanup",
  ];
  final Set<String> selectedCategories = {};

  // valid email
  bool isValidEmail(String input) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$").hasMatch(input);
  }

  // function to submit register gardener form to firestore
  void _registerGardener() async {
    // validate state
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Add provider to Firestore
      await database.registerGardener(
        nameController.text.trim(),
        contactController.text.trim(),
        emailController.text.trim(),
        locationController.text.trim(),
        servicesController.text.trim(),
        selectedCategories.toList(),
      );

      // go back to provider list page
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceProviderPage())
        );
      }
    } catch (e) {
      displayMessageToUser("Failed to register as a gardener", context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register as a Gardener"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Provider Name
                MyTextfield(
                  hintText: "Business / Provider Name",
                  obscureText: false,
                  controller: nameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 10),

                // Contact Info
                MyTextfield(
                  hintText: "Contact Number",
                  obscureText: false,
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value == null || value.length < 7
                      ? "Enter a valid phone number"
                      : null,
                ),
                const SizedBox(height: 10),

                // Email
                MyTextfield(
                  hintText: "Email Address",
                  obscureText: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter an email";
                    if (!value.contains("@")) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Location
                MyTextfield(
                  hintText: "Business Location",
                  obscureText: false,
                  controller: locationController,
                  validator: (value) => value == null || value.isEmpty
                      ? "Location is required"
                      : null,
                ),
                const SizedBox(height: 10),

                // Description
                MyTextfield(
                  hintText: "Services",
                  obscureText: false,
                  controller: servicesController,
                  maxLines: null,
                  minLines: 1,
                  maxLength: 250,
                  validator: (value) => value == null || value.isEmpty
                      ? "Description is required"
                      : null,
                ),
                const SizedBox(height: 25),

                // Categories Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Specialist Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),

                // Checkbox List
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
                    return CheckboxListTile(
                      title: Text(category),
                      value: selectedCategories.contains(category),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),

                // Submit Button
                MyButton(
                  text: _isLoading ? "Registering..." : "Register",
                  onTap: _isLoading ? null : _registerGardener,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}