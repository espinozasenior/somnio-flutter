import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';
import 'package:somnio/features/posts/domain/entities/post_entity.dart';

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

    test('copyWith returns new model with updated fields', () {
      final model = TestFixtures.postModel();
      final updated = model.copyWith(title: 'New Title', userId: 42);

      expect(updated.id, model.id);
      expect(updated.userId, 42);
      expect(updated.title, 'New Title');
      expect(updated.body, model.body);
    });

    test('copyWith with no args returns equal model', () {
      final model = TestFixtures.postModel();
      final copy = model.copyWith();

      expect(copy, equals(model));
    });

    test('toEntity maps all fields', () {
      final model = TestFixtures.postModel();
      final entity = model.toEntity();

      expect(entity, isA<PostEntity>());
      expect(entity.id, model.id);
      expect(entity.userId, model.userId);
      expect(entity.title, model.title);
      expect(entity.body, model.body);
    });

    test('toModel maps PostEntity back to PostModel', () {
      final entity = TestFixtures.postEntity();
      final model = entity.toModel();

      expect(model, isA<PostModel>());
      expect(model.id, entity.id);
      expect(model.userId, entity.userId);
      expect(model.title, entity.title);
      expect(model.body, entity.body);
    });

    test('two models with same data are equal', () {
      final a = TestFixtures.postModel();
      final b = TestFixtures.postModel();
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final model = TestFixtures.postModel();
      expect(
        model.props,
        equals([model.id, model.userId, model.title, model.body]),
      );
    });
  });
}
