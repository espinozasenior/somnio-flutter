import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:somnio/app/app.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    await configureDependencies();
  });

  testWidgets('full app smoke test', (tester) async {
    await tester.pumpWidget(
      App(
        router: getIt<AppRouter>().router,
        authCubit: getIt<AuthCubit>(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
