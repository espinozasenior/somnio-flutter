import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:somnio/features/posts/data/models/post_model.dart';

part 'post_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class PostRemoteDataSource {
  factory PostRemoteDataSource(Dio dio, {String baseUrl}) =
      _PostRemoteDataSource;

  @GET('/posts')
  Future<List<PostModel>> getPosts();

  @GET('/posts/{id}')
  Future<PostModel> getPostById(@Path('id') int id);
}
