import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:somnio/l10n/l10n.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ForgotPasswordPage', () {
    testWidgets('renders page with correct title', (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Reset your password'), findsOneWidget);
    });

    testWidgets('renders email field', (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      expect(find.byType(AuthFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders send reset link button', (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      expect(
        find.widgetWithText(FilledButton, 'Send Reset Link'),
        findsOneWidget,
      );
    });

    testWidgets('renders back to sign in button', (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      expect(
        find.widgetWithText(TextButton, 'Back to Sign In'),
        findsOneWidget,
      );
    });

    testWidgets('tapping send reset link does not throw',
        (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      await tester.tap(
        find.widgetWithText(FilledButton, 'Send Reset Link'),
      );
      await tester.pump();

      // No-op for now, verifies button is tappable without error.
      expect(find.text('Forgot Password'), findsOneWidget);
    });

    testWidgets('renders description text', (tester) async {
      await tester.pumpApp(const ForgotPasswordPage());

      expect(
        find.textContaining('Enter your email address'),
        findsOneWidget,
      );
    });

    testWidgets('back to sign in navigates to login', (tester) async {
      final router = GoRouter(
        initialLocation: '/forgot-password',
        routes: [
          GoRoute(
            path: '/forgot-password',
            builder: (_, _) => const ForgotPasswordPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (_, _) => const Scaffold(
              body: Text('Login Route'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(TextButton, 'Back to Sign In'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login Route'), findsOneWidget);
    });
  });
}
