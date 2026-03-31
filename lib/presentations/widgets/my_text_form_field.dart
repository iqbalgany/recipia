import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Color? fillColor;
  final TextStyle? hintStyle;
  const MyTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    this.validator,
    this.fillColor = Colors.white,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: Icon(icon, color: Colors.blue),
      ),
    );
  }
}
