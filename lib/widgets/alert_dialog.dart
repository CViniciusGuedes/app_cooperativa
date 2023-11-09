import 'package:flutter/material.dart';

class AlertDialogWidget {
  AlertDialogWidget._();

  static show(BuildContext context, String title, String message,
      {required Future<void> Function() onConfirm,
      Future<void> Function()? onCancel}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: createActions(context, onConfirm, onCancel),
        );
      },
    );
  }

  static List<Widget> createActions(BuildContext context,
      Future<void> Function() onConfirm, Future<void> Function()? onCancel) {
    final actions = <Widget>[
      TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await onConfirm.call();
          },
          child: const Text('Confirmar'))
    ];

    if (onCancel != null) {
      actions.add(TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await onCancel.call();
          },
          child: const Text('Cancelar')));
    }

    return actions;
  }
}
