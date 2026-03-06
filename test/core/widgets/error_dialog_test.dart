import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/widgets/error_dialog.dart';

import '../../helpers/helpers.dart';

void main() {
  group('showErrorDialog', () {
    testWidgets('shows AlertDialog with Error title and failure message',
        (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () => showErrorDialog(
              context,
              TestFixtures.serverFailure,
            ),
            child: const Text('Show'),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('dismisses dialog when OK is tapped', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => FilledButton(
            onPressed: () => showErrorDialog(
              context,
              TestFixtures.serverFailure,
            ),
            child: const Text('Show'),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
