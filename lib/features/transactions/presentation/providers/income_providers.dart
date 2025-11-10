// lib/features/transactions/presentation/providers/income_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/income_remote_datasource.dart';
import '../../data/repositories/income_repository.dart';
import '../../domain/models/income_model.dart';

// Data Source Provider
final incomeRemoteDataSourceProvider = Provider<IncomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return IncomeRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  final remoteDataSource = ref.watch(incomeRemoteDataSourceProvider);
  return IncomeRepository(remoteDataSource: remoteDataSource);
});

// Income List Provider
final incomeListProvider = FutureProvider<List<IncomeModel>>((ref) async {
  final repository = ref.watch(incomeRepositoryProvider);
  return repository.getAll();
});

// Income Total Provider
final incomeTotalProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(incomeRepositoryProvider);
  return repository.getTotal();
});

// Income By ID Provider
final incomeByIdProvider =
    FutureProvider.family<IncomeModel, String>((ref, id) async {
  final repository = ref.watch(incomeRepositoryProvider);
  return repository.getById(id);
});
