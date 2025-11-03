/// Custom text field(s) for EZPantry
library;

/// Core Packages
import 'package:flutter/material.dart';

/// A reusable TextField widget for login and registration forms.
class CustomTextField extends StatelessWidget { 

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText    = false,
    this.keyboardType   = TextInputType.text,
    this.icon,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });
  
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? icon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      maxLines: 1,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onSubmitted: (String value) {
        if (textInputAction == TextInputAction.next) {
          FocusScope.of(context).nextFocus();
        }
        if (onSubmitted != null) {
          onSubmitted!(value);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey), 
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),),
      ),
    );
  }
}
