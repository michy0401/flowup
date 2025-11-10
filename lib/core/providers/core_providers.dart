// lib/core/providers/core_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_storage_service.dart';
import '../services/api_client.dart';

/// Provider para el servicio de almacenamiento seguro
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider para el cliente API
final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return ApiClient(storageService: storageService);
});
