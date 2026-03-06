import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/widgets/error_view.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ErrorView', () {
    testWidgets('renders error icon and failure message', (tester) async {
      await tester.pumpApp(
        const ErrorView(failure: TestFixtures.serverFailure),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('renders retry button when onRetry is provided',
        (tester) async {
      await tester.pumpApp(
        ErrorView(
          failure: TestFixtures.serverFailure,
          onRetry: () {},
        ),
      );

      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('does not render retry button when onRetry is null',
        (tester) async {
      await tester.pumpApp(
        const ErrorView(failure: TestFixtures.serverFailure),
      );

      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retryCalled = false;

      await tester.pumpApp(
        ErrorView(
          failure: TestFixtures.serverFailure,
          onRetry: () => retryCalled = true,
        ),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Retry'));

      expect(retryCalled, isTrue);
    });
  });
}
