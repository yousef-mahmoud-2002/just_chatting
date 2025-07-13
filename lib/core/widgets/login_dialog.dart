import 'package:flutter/material.dart';

loginDialog(context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(6),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
