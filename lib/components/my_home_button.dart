import 'package:flutter/material.dart';

class MyHomeButton extends StatelessWidget {
  const MyHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
        '/home_page', (route) => false
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10), 
        child: Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}