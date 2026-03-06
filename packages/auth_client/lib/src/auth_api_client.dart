import 'package:auth_client/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/auth/mobile/google')
  Future<AuthResponse> googleSignIn(@Body() SocialLoginRequest request);

  @POST('/auth/mobile/apple')
  Future<AuthResponse> appleSignIn(@Body() SocialLoginRequest request);

  @POST('/auth/refresh-token')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  @POST('/auth/change-password')
  Future<void> changePassword(@Body() ChangePasswordRequest request);

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/auth/{id}')
  Future<AuthResponse> getAuthById(@Path('id') String id);

  @DELETE('/auth/{id}')
  Future<void> deleteAccount(@Path('id') String id);

  @GET('/profile/me')
  Future<ProfileResponse> getProfile();

  @PUT('/profile/me')
  Future<ProfileResponse> updateProfile(@Body() Map<String, dynamic> data);

  @POST('/profile')
  Future<ProfileResponse> createProfile(@Body() Map<String, dynamic> data);
}
