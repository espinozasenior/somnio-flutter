import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:somnio/core/error/exceptions.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';

class PostLocalDataSource {
  PostLocalDataSource(this._box);

  final Box<String> _box;

  static const _postsKey = 'cached_posts';

  Future<List<PostModel>> getCachedPosts() async {
    final jsonString = _box.get(_postsKey);
    if (jsonString == null) {
      throw const CacheException(message: 'No cached posts');
    }
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> cachePosts(List<PostModel> posts) async {
    final jsonString = jsonEncode(
      posts.map((e) => e.toJson()).toList(),
    );
    await _box.put(_postsKey, jsonString);
  }
}
