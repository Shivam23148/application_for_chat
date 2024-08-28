import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.textEditingController,
      this.keyBoardType,
      this.focusNode});
  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final TextInputType? keyBoardType;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyBoardType,
      controller: textEditingController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText),
    );
  }
}
