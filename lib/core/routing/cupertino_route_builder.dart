import 'package:flutter/cupertino.dart';

Page<T> buildCupertinoPage<T>({
  required Widget child,
  required String name,
}) {
  return CupertinoPage<T>(
    child: child,
    name: name,
  );
}
