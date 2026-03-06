import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/presentation/widgets/auth_form_field.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('AuthFormField', () {
    testWidgets('renders TextField with label text', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: AuthFormField(labelText: 'Email'),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('shows error text when provided', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: AuthFormField(
            labelText: 'Email',
            errorText: 'Invalid email',
          ),
        ),
      );

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows hint text when provided', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: AuthFormField(
            labelText: 'Email',
            hintText: 'Enter your email',
          ),
        ),
      );

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('calls onChanged when text entered', (tester) async {
      String? changedValue;

      await tester.pumpApp(
        Scaffold(
          body: AuthFormField(
            labelText: 'Email',
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@example.com');

      expect(changedValue, equals('test@example.com'));
    });

    testWidgets('renders prefix and suffix icons', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: AuthFormField(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('obscures text when obscureText is true', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: AuthFormField(
            labelText: 'Password',
            obscureText: true,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });
}
