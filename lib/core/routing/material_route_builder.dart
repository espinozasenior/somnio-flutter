import 'package:flutter/material.dart';

Page<T> buildMaterialPage<T>({
  required Widget child,
  required String name,
}) {
  return MaterialPage<T>(
    child: child,
    name: name,
  );
}
