import 'package:flutter/cupertino.dart';

class CupertinoLoadingView extends StatelessWidget {
  const CupertinoLoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 16),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
          ],
        ],
      ),
    );
  }
}
