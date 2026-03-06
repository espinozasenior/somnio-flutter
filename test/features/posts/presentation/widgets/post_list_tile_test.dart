import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/posts/presentation/widgets/post_list_tile.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$PostListTile', () {
    final post = TestFixtures.postEntity();

    testWidgets('renders post title and body', (tester) async {
      await tester.pumpApp(
        PostListTile(post: post, onTap: () {}),
      );

      expect(find.text(post.title), findsOneWidget);
      expect(find.text(post.body), findsOneWidget);
    });

    testWidgets('renders chevron right icon', (tester) async {
      await tester.pumpApp(
        PostListTile(post: post, onTap: () {}),
      );

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpApp(
        PostListTile(post: post, onTap: () => tapped = true),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });
  });
}
