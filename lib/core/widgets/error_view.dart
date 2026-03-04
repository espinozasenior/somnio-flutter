import 'package:flutter/cupertino.dart';
import 'package:somnio/core/error/failures.dart';

class CupertinoErrorView extends StatelessWidget {
  const CupertinoErrorView({
    required this.failure,
    this.onRetry,
    super.key,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 48,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 16),
            Text(
              failure.message,
              style: CupertinoTheme.of(context).textTheme.textStyle,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
