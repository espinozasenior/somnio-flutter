import 'package:app_ui/app_ui.dart' show AppColors;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/app/theme/app_theme.dart';

void main() {
  group('$AppTheme', () {
    test('lightTheme has ${Brightness.light}', () {
      expect(AppTheme.lightTheme.brightness, Brightness.light);
    });

    test('darkTheme has ${Brightness.dark}', () {
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
    });

    test('lightTheme primary color matches AppColors.primary', () {
      expect(
        AppTheme.lightTheme.colorScheme.primary,
        AppColors.primary,
      );
    });

    test('darkTheme primary color matches AppColors.darkPrimary', () {
      expect(
        AppTheme.darkTheme.colorScheme.primary,
        AppColors.darkPrimary,
      );
    });
  });
}
