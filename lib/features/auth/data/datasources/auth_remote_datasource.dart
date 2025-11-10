// lib/features/auth/data/datasources/auth_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Registrar nuevo usuario
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authRegister,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    return AuthResponseModel.fromJson(response.data);
  }

  /// Iniciar sesión
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.authLogin,
      body: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
    );

    return AuthResponseModel.fromJson(response.data);
  }

  /// Solicitar restablecimiento de contraseña
  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post(
      ApiConstants.authForgotPassword,
      body: {'email': email},
      requiresAuth: false,
    );
  }

  /// Restablecer contraseña
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiConstants.authResetPassword,
      body: {
        'token': token,
        'newPassword': newPassword,
      },
      requiresAuth: false,
    );
  }
}
