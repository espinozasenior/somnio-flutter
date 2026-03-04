import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/app/app.dart';

void main() {
  group('$App', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) => const CupertinoPageScaffold(
              child: Center(child: Text('Test')),
            ),
          ),
        ],
      );
    });

    testWidgets('renders $CupertinoApp', (tester) async {
      await tester.pumpWidget(App(router: router));
      expect(find.byType(CupertinoApp), findsOneWidget);
    });
  });
}
