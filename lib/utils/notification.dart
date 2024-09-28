import 'package:flutter/material.dart';

class Notifications {
  static showNotification(context, data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data), showCloseIcon: true),
    );
  }
}
