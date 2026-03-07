import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:somnio/core/network/network_info.dart';
import 'package:somnio/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:somnio/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:somnio/features/auth/domain/repositories/auth_repository.dart';
import 'package:somnio/features/auth/domain/usecases/login_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/logout_usecase.dart';
import 'package:somnio/features/auth/domain/usecases/register_usecase.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_state.dart';
import 'package:somnio/features/auth/presentation/cubit/login_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/login_state.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/signup_state.dart';
import 'package:somnio/features/posts/data/datasources/local/post_local_data_source.dart';
import 'package:somnio/features/posts/data/datasources/remote/post_remote_data_source.dart';
import 'package:somnio/features/posts/domain/repositories/post_repository.dart';
import 'package:somnio/features/posts/domain/usecases/get_post_by_id.dart';
import 'package:somnio/features/posts/domain/usecases/get_posts.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:somnio/features/posts/presentation/cubit/posts_state.dart';
import 'package:user_repository/user_repository.dart';

// Repository mocks
class MockPostRepository extends Mock implements PostRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

// Data source mocks
class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

// Network mocks
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockConnectivity extends Mock implements Connectivity {}

// Use case mocks
class MockGetPosts extends Mock implements GetPosts {}

class MockGetPostById extends Mock implements GetPostById {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

// Cubit mocks
class MockPostsCubit extends MockCubit<PostsState> implements PostsCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

class MockSignupCubit extends MockCubit<SignupState> implements SignupCubit {}
