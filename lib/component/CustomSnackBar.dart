import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String istenen) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(child: Text(istenen)),
    duration: const Duration(seconds: 2),
  ));
}
