import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String? location;
  final String? description;
  final String? budget;
  final VoidCallback? onTap;

  const MyListTile({
    super.key, 
    required this.title, 
    required this.location,
    this.description,
    this.budget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location != null ? "$title " : title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "$location",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
