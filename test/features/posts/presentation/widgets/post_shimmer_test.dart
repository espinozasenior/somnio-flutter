import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:somnio/features/posts/presentation/widgets/post_shimmer.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$PostShimmer', () {
    testWidgets('renders default 5 shimmer items', (tester) async {
      await tester.pumpApp(const PostShimmer());

      expect(find.byType(Shimmer), findsNWidgets(5));
    });

    testWidgets('renders custom item count', (tester) async {
      await tester.pumpApp(const PostShimmer(itemCount: 3));

      expect(find.byType(Shimmer), findsNWidgets(3));
    });
  });
}
