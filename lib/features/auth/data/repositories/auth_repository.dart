// lib/features/auth/data/repositories/auth_repository.dart
import '../../../../core/services/secure_storage_service.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/models/auth_response_model.dart';
import '../../domain/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService storageService,
  })  : _remoteDataSource = remoteDataSource,
        _storageService = storageService;

  /// Registrar nuevo usuario
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );

    // Guardar token y datos del usuario
    final token = response.authToken;
    if (token != null && response.user != null) {
      await _storageService.saveToken(token);
      await _storageService.saveUserData(
        userId: response.user!.id,
        email: response.user!.email,
        name: response.user!.name,
      );
    }

    return response.user!;
  }

  /// Iniciar sesión
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    // Guardar token y datos del usuario
    final token = response.authToken;
    if (token != null && response.user != null) {
      await _storageService.saveToken(token);
      await _storageService.saveUserData(
        userId: response.user!.id,
        email: response.user!.email,
        name: response.user!.name,
      );
    }

    return response.user!;
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await _storageService.clearAll();
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await _storageService.isAuthenticated();
  }

  /// Obtener información del usuario almacenada localmente
  Future<Map<String, String?>> getUserData() async {
    return {
      'id': await _storageService.getUserId(),
      'email': await _storageService.getUserEmail(),
      'name': await _storageService.getUserName(),
    };
  }

  /// Solicitar restablecimiento de contraseña
  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email: email);
  }

  /// Restablecer contraseña
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _remoteDataSource.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }
}
