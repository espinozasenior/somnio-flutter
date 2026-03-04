import 'package:flutter/cupertino.dart';
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

    test('lightTheme primaryColor is systemBlue', () {
      expect(
        AppTheme.lightTheme.primaryColor,
        CupertinoColors.systemBlue,
      );
    });

    test('darkTheme primaryColor is systemBlue', () {
      expect(
        AppTheme.darkTheme.primaryColor,
        CupertinoColors.systemBlue,
      );
    });
  });
}
