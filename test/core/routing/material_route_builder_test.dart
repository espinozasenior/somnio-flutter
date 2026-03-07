import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/core/routing/material_route_builder.dart';

void main() {
  group('buildMaterialPage', () {
    test('returns MaterialPage with correct child and name', () {
      const child = SizedBox();

      final page = buildMaterialPage<void>(
        child: child,
        name: 'test-page',
      );

      expect(page, isA<MaterialPage<void>>());

      final materialPage = page as MaterialPage<void>;
      expect(materialPage.child, equals(child));
      expect(materialPage.name, equals('test-page'));
    });
  });
}
