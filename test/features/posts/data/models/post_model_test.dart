import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('$PostModel', () {
    test('fromJson parses valid JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'userId': 1,
        'title': 'Test Post 1',
        'body': 'Test body for post 1',
      };

      final model = PostModel.fromJson(json);

      expect(model.id, 1);
      expect(model.userId, 1);
      expect(model.title, 'Test Post 1');
      expect(model.body, 'Test body for post 1');
    });

    test('toJson serializes correctly', () {
      final model = TestFixtures.postModel();
      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['userId'], 1);
      expect(json['title'], 'Test Post 1');
      expect(json['body'], 'Test body for post 1');
    });

    test('toEntity maps all fields', () {
      final model = TestFixtures.postModel();
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.userId, model.userId);
      expect(entity.title, model.title);
      expect(entity.body, model.body);
    });

    test('two models with same data are equal', () {
      final a = TestFixtures.postModel();
      final b = TestFixtures.postModel();
      expect(a, equals(b));
    });
  });
}
