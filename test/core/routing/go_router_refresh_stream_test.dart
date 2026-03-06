import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/routing/go_router_refresh_stream.dart';

void main() {
  group('$GoRouterRefreshStream', () {
    test('notifies listeners on stream events', () async {
      final controller = StreamController<int>.broadcast();
      final refreshStream = GoRouterRefreshStream(controller.stream);

      var notifyCount = 0;
      refreshStream.addListener(() => notifyCount++);

      // Initial notify happens in constructor, reset count
      notifyCount = 0;

      controller
        ..add(1)
        ..add(2);

      // Allow microtasks to complete
      await Future<void>.delayed(Duration.zero);
      expect(notifyCount, 2);
      refreshStream.dispose();
      await controller.close();
    });

    test('dispose cancels subscription', () async {
      final controller = StreamController<int>.broadcast();
      GoRouterRefreshStream(controller.stream).dispose();
      await controller.close();
    });
  });
}
