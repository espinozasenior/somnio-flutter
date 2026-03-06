import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/widgets/loading_view.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoadingView', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpApp(const LoadingView());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders message when provided', (tester) async {
      await tester.pumpApp(const LoadingView(message: 'Loading data...'));

      expect(find.text('Loading data...'), findsOneWidget);
    });

    testWidgets('does not render message text when null', (tester) async {
      await tester.pumpApp(const LoadingView());

      expect(find.byType(Text), findsNothing);
    });
  });
}
