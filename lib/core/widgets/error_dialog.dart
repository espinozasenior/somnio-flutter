import 'package:flutter/cupertino.dart';
import 'package:somnio/core/error/failures.dart';

Future<void> showCupertinoErrorDialog(
  BuildContext context,
  Failure failure,
) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(failure.message),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
