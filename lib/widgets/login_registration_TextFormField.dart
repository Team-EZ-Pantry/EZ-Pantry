/// A reusable TextField widget for login and registration forms.
import 'package:flutter/material.dart';
import 'package:ez_pantry/screens/login_page.dart.';

class RegistrationLoginTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? icon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted; 

  const RegistrationLoginTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText    = false,
    this.keyboardType   = TextInputType.text,
    this.icon,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (String value) {},
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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
