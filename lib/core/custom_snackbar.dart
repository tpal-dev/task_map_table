import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar._();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show({
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }
}
