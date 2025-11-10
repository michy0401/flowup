// lib/features/categories/presentation/providers/category_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/models/category_model.dart';

// Data Source Provider
final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoryRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepository(remoteDataSource: remoteDataSource);
});

// Category List Provider
final categoryListProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAll();
});

// Category By Scope Provider
final categoryByScopeProvider =
    FutureProvider.family<List<CategoryModel>, String>((ref, scope) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAll(scope: scope);
});

// Category By ID Provider
final categoryByIdProvider =
    FutureProvider.family<CategoryModel, String>((ref, id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getById(id);
});
