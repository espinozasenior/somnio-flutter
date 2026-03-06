import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/extensions/context_extensions.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ContextExtensions', () {
    testWidgets('theme returns ThemeData', (tester) async {
      late ThemeData captured;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            captured = context.theme;
            return const SizedBox();
          },
        ),
      );

      expect(captured, isA<ThemeData>());
    });

    testWidgets('textTheme returns TextTheme', (tester) async {
      late TextTheme captured;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            captured = context.textTheme;
            return const SizedBox();
          },
        ),
      );

      expect(captured, isA<TextTheme>());
    });

    testWidgets('colorScheme returns ColorScheme', (tester) async {
      late ColorScheme captured;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            captured = context.colorScheme;
            return const SizedBox();
          },
        ),
      );

      expect(captured, isA<ColorScheme>());
    });

    testWidgets('mediaQuery returns MediaQueryData', (tester) async {
      late MediaQueryData captured;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            captured = context.mediaQuery;
            return const SizedBox();
          },
        ),
      );

      expect(captured, isA<MediaQueryData>());
    });

    testWidgets('screenSize returns Size', (tester) async {
      late Size captured;

      await tester.pumpApp(
        Builder(
          builder: (context) {
            captured = context.screenSize;
            return const SizedBox();
          },
        ),
      );

      expect(captured, isA<Size>());
    });

    testWidgets('isDarkMode returns true for dark theme', (tester) async {
      late bool captured;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) {
              captured = context.isDarkMode;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured, isTrue);
    });

    testWidgets('isDarkMode returns false for light theme', (tester) async {
      late bool captured;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              captured = context.isDarkMode;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured, isFalse);
    });
  });
}
