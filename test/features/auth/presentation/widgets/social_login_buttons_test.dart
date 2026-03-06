import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/auth/presentation/widgets/social_login_buttons.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('SocialLoginButtons', () {
    testWidgets('renders Google and Apple buttons', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: SocialLoginButtons(),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNWidgets(2));
    });

    testWidgets('calls onGooglePressed when Google button tapped',
        (tester) async {
      var googlePressed = false;

      await tester.pumpApp(
        Scaffold(
          body: SocialLoginButtons(
            onGooglePressed: () => googlePressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Continue with Google'));

      expect(googlePressed, isTrue);
    });

    testWidgets('calls onApplePressed when Apple button tapped',
        (tester) async {
      var applePressed = false;

      await tester.pumpApp(
        Scaffold(
          body: SocialLoginButtons(
            onApplePressed: () => applePressed = true,
          ),
        ),
      );

      await tester.tap(find.text('Continue with Apple'));

      expect(applePressed, isTrue);
    });
  });
}
