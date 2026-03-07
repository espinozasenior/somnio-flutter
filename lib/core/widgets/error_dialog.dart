import 'package:flutter/material.dart';
import 'package:somnio/core/error/failures.dart';

Future<void> showErrorDialog(
  BuildContext context,
  Failure failure,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(failure.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
