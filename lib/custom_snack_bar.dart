import 'package:flutter/material.dart';

class MySnackBar {
  static SnackBar createSnackBar({
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required String text,
    required IconData icon,
  }) {
    return SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          25.0,
        ),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      content: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        leading: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
