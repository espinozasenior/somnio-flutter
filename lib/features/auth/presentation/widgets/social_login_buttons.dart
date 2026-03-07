import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    this.onGooglePressed,
    this.onApplePressed,
    super.key,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: onGooglePressed,
          icon: const Icon(Icons.g_mobiledata, size: 24),
          label: const Text('Continue with Google'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onApplePressed,
          icon: const Icon(Icons.apple, size: 24),
          label: const Text('Continue with Apple'),
        ),
      ],
    );
  }
}
