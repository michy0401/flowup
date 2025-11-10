// lib/core/services/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'secure_storage_service.dart';

/// Cliente HTTP para realizar llamadas a la API con autenticación JWT
class ApiClient {
  final SecureStorageService _storageService;
  final http.Client _httpClient;

  ApiClient({
    required SecureStorageService storageService,
    http.Client? httpClient,
  })  : _storageService = storageService,
        _httpClient = httpClient ?? http.Client();

  /// Construye los headers para las peticiones
  Future<Map<String, String>> _buildHeaders({
    bool requiresAuth = true,
  }) async {
    final headers = {
      'Content-Type': ApiConstants.contentType,
      'Accept': ApiConstants.contentType,
    };

    if (requiresAuth) {
      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    }

    return headers;
  }

  /// Construye la URL completa
  Uri _buildUrl(String path, {Map<String, dynamic>? queryParameters}) {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }
    return uri;
  }

  // ========== GET ==========
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(path, queryParameters: queryParameters);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _httpClient
          .get(url, headers: headers)
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No hay conexión a internet',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Error de conexión con el servidor',
        statusCode: 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // ========== POST ==========
  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(path, queryParameters: queryParameters);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _httpClient
          .post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No hay conexión a internet',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Error de conexión con el servidor',
        statusCode: 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // ========== PUT ==========
  Future<ApiResponse> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(path, queryParameters: queryParameters);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _httpClient
          .put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No hay conexión a internet',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Error de conexión con el servidor',
        statusCode: 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // ========== PATCH ==========
  Future<ApiResponse> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(path, queryParameters: queryParameters);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _httpClient
          .patch(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No hay conexión a internet',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Error de conexión con el servidor',
        statusCode: 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // ========== DELETE ==========
  Future<ApiResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final url = _buildUrl(path, queryParameters: queryParameters);
      final headers = await _buildHeaders(requiresAuth: requiresAuth);

      final response = await _httpClient
          .delete(url, headers: headers)
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        message: 'No hay conexión a internet',
        statusCode: 0,
      );
    } on HttpException {
      throw ApiException(
        message: 'Error de conexión con el servidor',
        statusCode: 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Error inesperado: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  // ========== RESPONSE HANDLER ==========
  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    // Intentar parsear el body como JSON
    dynamic data;
    try {
      if (body.isNotEmpty) {
        data = jsonDecode(body);
      }
    } catch (e) {
      data = body;
    }

    // Manejo de códigos de estado
    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(
        statusCode: statusCode,
        data: data,
        success: true,
      );
    } else if (statusCode == 401) {
      throw ApiException(
        message: 'No autorizado. Por favor, inicia sesión nuevamente.',
        statusCode: statusCode,
        data: data,
      );
    } else if (statusCode == 403) {
      throw ApiException(
        message: 'No tienes permisos para realizar esta acción.',
        statusCode: statusCode,
        data: data,
      );
    } else if (statusCode == 404) {
      throw ApiException(
        message: 'Recurso no encontrado.',
        statusCode: statusCode,
        data: data,
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      final errorMessage =
          data is Map && data.containsKey('message')
              ? data['message']
              : 'Error en la petición';
      throw ApiException(
        message: errorMessage,
        statusCode: statusCode,
        data: data,
      );
    } else if (statusCode >= 500) {
      throw ApiException(
        message: 'Error del servidor. Intenta de nuevo más tarde.',
        statusCode: statusCode,
        data: data,
      );
    } else {
      throw ApiException(
        message: 'Error desconocido',
        statusCode: statusCode,
        data: data,
      );
    }
  }

  /// Cierra el cliente HTTP
  void dispose() {
    _httpClient.close();
  }
}

/// Clase para la respuesta de la API
class ApiResponse {
  final int statusCode;
  final dynamic data;
  final bool success;

  ApiResponse({
    required this.statusCode,
    required this.data,
    required this.success,
  });
}

/// Clase para las excepciones de la API
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
