import 'package:flutter/material.dart';

class SnackbarNotificationWidget {
  SnackbarNotificationWidget._();

  static error(BuildContext context, String title, String message) {
    show(context, title, message, color: Colors.red);
  }

  static warn(BuildContext context, String title, String message) {
    show(context, title, message, color: Colors.orange);
  }

  static info(BuildContext context, String title, String message) {
    show(context, title, message, color: Colors.blue);
  }

  static show(BuildContext context, String title, String message,
      {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.startToEnd,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: title,
            textColor: Colors.white,
            onPressed: () {},
          ),
          content: Row(
            children: [
              const Icon(
                Icons.info,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(message),
            ],
          )),
    );
  }
}
