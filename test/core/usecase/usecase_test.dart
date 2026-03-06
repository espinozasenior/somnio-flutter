import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/usecase/usecase.dart';

void main() {
  group('NoParams', () {
    test('has empty props', () {
      const params = NoParams();
      expect(params.props, isEmpty);
    });

    test('two NoParams are equal', () {
      const a = NoParams();
      const b = NoParams();
      expect(a, b);
    });
  });
}
