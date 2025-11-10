// lib/features/transactions/presentation/providers/expense_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository.dart';
import '../../domain/models/expense_model.dart';

// Data Source Provider
final expenseRemoteDataSourceProvider = Provider<ExpenseRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExpenseRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final remoteDataSource = ref.watch(expenseRemoteDataSourceProvider);
  return ExpenseRepository(remoteDataSource: remoteDataSource);
});

// Expense List Provider
final expenseListProvider = FutureProvider<List<ExpenseModel>>((ref) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getAll();
});

// Expense Total Provider
final expenseTotalProvider = FutureProvider<String>((ref) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getTotal();
});

// Expense By ID Provider
final expenseByIdProvider =
    FutureProvider.family<ExpenseModel, String>((ref, id) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getById(id);
});
