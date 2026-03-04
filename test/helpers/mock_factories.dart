import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';

// Repository mocks
class MockPostRepository extends Mock implements PostRepository {}

// Data source mocks
class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

// Network mocks
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockConnectivity extends Mock implements Connectivity {}

// Use case mocks
class MockGetPosts extends Mock implements GetPosts {}

class MockGetPostById extends Mock implements GetPostById {}

// Cubit mocks
class MockPostsCubit extends MockCubit<PostsState> implements PostsCubit {}
