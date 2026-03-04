import 'package:flutter/cupertino.dart';

/// Wraps a widget in a [CupertinoApp] for golden tests.
Widget buildGoldenTestWidget(Widget widget) {
  return CupertinoApp(
    debugShowCheckedModeBanner: false,
    home: widget,
  );
}

/// Tag for conditional golden test execution.
const goldenTag = 'golden';

/// Tolerance for golden image comparison.
const goldenTolerance = 0.05;
