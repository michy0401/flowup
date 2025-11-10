// lib/features/investments/presentation/providers/investment_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/investment_remote_datasource.dart';
import '../../data/repositories/investment_repository.dart';
import '../../domain/models/investment_model.dart';

// Data Source Provider
final investmentRemoteDataSourceProvider =
    Provider<InvestmentRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InvestmentRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) {
  final remoteDataSource = ref.watch(investmentRemoteDataSourceProvider);
  return InvestmentRepository(remoteDataSource: remoteDataSource);
});

// Investment List Provider
final investmentListProvider = FutureProvider<List<InvestmentModel>>((ref) async {
  final repository = ref.watch(investmentRepositoryProvider);
  return repository.getAll();
});

// Investment Total Provider
final investmentTotalProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(investmentRepositoryProvider);
  return repository.getTotal();
});

// Investment By ID Provider
final investmentByIdProvider =
    FutureProvider.family<InvestmentModel, String>((ref, id) async {
  final repository = ref.watch(investmentRepositoryProvider);
  return repository.getById(id);
});
