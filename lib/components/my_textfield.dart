import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final bool autofocus;

    const MyTextfield({
      super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.validator,
      this.keyboardType,
      this.inputFormatters,
      this.maxLines = 1,
      this.maxLength,
      this.minLines,
      this.textCapitalization = TextCapitalization.none,
      this.autofocus = false,
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
      ),
    );
  }
}