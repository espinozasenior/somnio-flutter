import 'package:app_ui/app_ui.dart' as ui;
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => ui.AppTheme.lightTheme;
  static ThemeData get darkTheme => ui.AppTheme.darkTheme;
}
