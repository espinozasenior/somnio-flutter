import 'package:flutter/cupertino.dart';

abstract final class AppTheme {
  static const lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemBlue,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.label,
    ),
  );

  static const darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemBlue,
    scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
    ),
  );
}
