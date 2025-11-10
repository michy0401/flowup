// lib/features/auth/presentation/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../../../core/services/api_client.dart';

// ========== DATA SOURCE PROVIDER ==========
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient: apiClient);
});

// ========== REPOSITORY PROVIDER ==========
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthRepository(
    remoteDataSource: remoteDataSource,
    storageService: storageService,
  );
});

// ========== AUTH STATE PROVIDER ==========
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthStateNotifier(repository: repository);
  },
);

// ========== AUTH STATE ==========
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// ========== AUTH STATE NOTIFIER ==========
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthStateNotifier({required AuthRepository repository})
      : _repository = repository,
        super(AuthState()) {
    _checkAuthentication();
  }

  /// Verifica si el usuario está autenticado al iniciar
  Future<void> _checkAuthentication() async {
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      final userData = await _repository.getUserData();
      state = state.copyWith(
        isAuthenticated: true,
        user: UserModel(
          id: userData['id'] ?? '',
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
        ),
      );
    }
  }

  /// Registrar nuevo usuario
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Iniciar sesión
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(); // Reset state
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
