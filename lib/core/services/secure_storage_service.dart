// lib/core/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para almacenar datos de forma segura (como tokens JWT)
class SecureStorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  // ========== TOKEN ==========

  /// Guarda el token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Obtiene el token JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Elimina el token JWT
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // ========== USER DATA ==========

  /// Guarda los datos del usuario
  Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyUserEmail, value: email);
    await _storage.write(key: _keyUserName, value: name);
  }

  /// Obtiene el ID del usuario
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Obtiene el email del usuario
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Obtiene el nombre del usuario
  Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }

  // ========== CLEAR ALL ==========

  /// Limpia todos los datos almacenados (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica si el usuario está autenticado (tiene token)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
