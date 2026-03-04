import 'package:flutter/cupertino.dart';

extension ContextExtensions on BuildContext {
  CupertinoThemeData get theme => CupertinoTheme.of(this);

  CupertinoTextThemeData get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
