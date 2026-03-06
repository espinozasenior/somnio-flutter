import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/app/app.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_state.dart';

import '../../helpers/mock_factories.dart';

void main() {
  group('$App', () {
    late GoRouter router;
    late MockAuthCubit mockAuthCubit;

    setUp(() {
      mockAuthCubit = MockAuthCubit();
      when(() => mockAuthCubit.state).thenReturn(const AuthState());
      when(() => mockAuthCubit.stream).thenAnswer(
        (_) => const Stream<AuthState>.empty(),
      );

      router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) => const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ],
      );
    });

    testWidgets('renders $MaterialApp', (tester) async {
      await tester.pumpWidget(
        App(router: router, authCubit: mockAuthCubit),
      );
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
