import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInput({
    super.key,
    required this.label,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}