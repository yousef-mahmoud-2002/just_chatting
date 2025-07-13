import 'package:flutter/material.dart';
import 'package:just_chatting/constants.dart';

class CustomSecureTextFormField extends StatefulWidget {
  const CustomSecureTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.focusNode,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  State<CustomSecureTextFormField> createState() =>
      _CustomSecureTextFormFieldState();
}

class _CustomSecureTextFormFieldState extends State<CustomSecureTextFormField> {
  bool secure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      obscureText: secure,
      controller: widget.controller,
      onTapOutside: (event) {
        widget.focusNode?.unfocus();
      },
      keyboardType: TextInputType.visiblePassword,
      cursorColor: kPrimaryColor,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field is required';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: 'Enter your ${widget.label}',
        labelStyle: const TextStyle(color: kPrimaryColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        filled: true,
        labelText: widget.label,
        border: defualtBorder(),
        focusedBorder: defualtBorder(),
        enabledBorder: defualtBorder(),
        prefixIcon: Icon(widget.icon),
        suffixIcon: IconButton(
          icon: secure
              ? const Icon(Icons.visibility_outlined)
              : const Icon(Icons.visibility_off_outlined),
          onPressed: () {
            setState(() {
              secure = !secure;
            });
          },
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.textInputType,
    required this.controller,
    this.focusNode,
  });

  final String label;
  final IconData icon;
  final TextInputType textInputType;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onTapOutside: (event) {
        focusNode?.unfocus();
      },
      keyboardType: textInputType,
      cursorColor: kPrimaryColor,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field is required';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: kPrimaryColor),
        hintText: 'Enter your $label',
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        filled: true,
        labelText: label,
        border: defualtBorder(),
        focusedBorder: defualtBorder(),
        enabledBorder: defualtBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}

OutlineInputBorder defualtBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: kPrimaryColor.withValues(alpha: 0.5),
    ),
  );
}
