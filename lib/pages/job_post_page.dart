import 'package:easygarden/components/my_button.dart';
import 'package:easygarden/components/my_textfield.dart';
import 'package:easygarden/database/firestore.dart';
import 'package:easygarden/helper/helper_functions.dart';
import 'package:flutter/material.dart';

class JobPostPage extends StatefulWidget {
  const JobPostPage({super.key});

  @override
  State<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  
  // Tag options
  final List<String> availableTags = [
    'Lawn mowing',
    'Gutter cleaning',
    'Hedge trimming',
    'General cleaning',
    'House maintenance',
  ];

  List<String> selectedTags = [];

  // Job type options
  final List<String> jobTypes = ['One-off', 'Routine job'];
  String? selectedJobType; // optional

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // Function to post job to Firestore
  void _postJob() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Add job to Firestore
      await database.postJob(
        titleController.text.trim(),
        descriptionController.text.trim(),
        locationController.text.trim(),
        budgetController.text.trim(),
        contactController.text.trim(),
        selectedTags,
        selectedJobType,
      );

      // go back to home page
      if (context.mounted) {
        displayMessageToUser("Job has been posted successfully!", context);
        Navigator.pushNamedAndRemoveUntil(context, '/home_page', (route) => false);
      }
    } catch (e) {
      displayMessageToUser("Failed to post a job", context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Post a Job")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key:_formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // fill in job title
                      MyTextfield(
                        hintText: "Job Title",
                        obscureText: false,
                        controller: titleController,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a job title' : null,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                      ),

                      const SizedBox(height: 5),

                      // fill in description
                      MyTextfield(
                        hintText: "Description",
                        obscureText: false,
                        controller: descriptionController,
                        maxLines: null,
                        minLines: 1,
                        maxLength: 250,
                        validator: (value) => value == null || value.isEmpty
                            ? "Description is required"
                            : null,
                      ),

                      const SizedBox(height: 5),

                      // fill in location
                      MyTextfield(
                        hintText: "Location",
                        obscureText: false,
                        controller: locationController,
                        validator: (value) => value == null || value.isEmpty
                              ? "Location is required"
                              : null,
                      ),

                      const SizedBox(height: 5),

                      // fill in budget
                      MyTextfield(
                        hintText: "Budget (e.g. \$50 - \$100)",
                        obscureText: false,
                        controller: budgetController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Budget is required";
                          }
                          // Optional: You can add more specific validation for the format of the budget.
                          return null;
                        },
                      ),

                      const SizedBox(height: 5),

                      // fill in contact number
                      MyTextfield(
                        hintText: "Contact number",
                        obscureText: false,
                        controller: contactController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Contact number is required";
                          }
                          // Validate phone number length
                          if (value.length < 7 || value.length > 15) {
                            return "Enter a valid phone number";
                          }
                          // Optionally, add more checks for specific phone number formats
                          return null;
                        },
                      ),

                      const SizedBox(height: 5),

                      // Tags as dropdown or compact wrap
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: "Job Type (optional)"),
                        value: selectedJobType,
                        items: jobTypes
                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedJobType = value;
                          });
                        },
                      ),
                      SizedBox(height: 6),

                      // Tags as wrap
                      Wrap(
                        spacing: 4.0,
                        children: availableTags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag, style: TextStyle(fontSize: 12)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // post job and store in 
                MyButton(
                  text: _isLoading ? "Posting..." : "Post Job",
                  onTap: _isLoading ? null : _postJob,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}