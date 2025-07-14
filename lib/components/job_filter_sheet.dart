import 'package:flutter/material.dart';

class JobFilterSheet extends StatefulWidget {
  const JobFilterSheet({super.key});

  @override
  State<JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<JobFilterSheet> {
  final TextEditingController keywordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: keywordController,
            decoration: const InputDecoration(labelText: 'Keyword'),
          ),
          TextField(
            controller: locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Category'),
            value: selectedCategory,
            items: ['Mowing', 'Planting', 'Pruning', 'Weeding']
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedCategory = val;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'keyword': keywordController.text.trim(),
                'location': locationController.text.trim(),
                'category': selectedCategory,
              });
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}