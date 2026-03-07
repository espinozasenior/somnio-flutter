import 'package:app_ui/src/app_spacing.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: AppSpacing.lg,
              width: AppSpacing.lg,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : child,
    );
  }
}
