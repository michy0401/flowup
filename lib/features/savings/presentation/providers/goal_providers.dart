// lib/features/savings/presentation/providers/goal_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/goal_remote_datasource.dart';
import '../../data/repositories/goal_repository.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/models/contribution_model.dart';

// Data Source Provider
final goalRemoteDataSourceProvider = Provider<GoalRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GoalRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final remoteDataSource = ref.watch(goalRemoteDataSourceProvider);
  return GoalRepository(remoteDataSource: remoteDataSource);
});

// Goal List Provider
final goalListProvider = FutureProvider<List<GoalModel>>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getAll();
});

// Goal By ID Provider
final goalByIdProvider =
    FutureProvider.family<GoalModel, String>((ref, id) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getById(id);
});

// Goal Contributions Provider
final goalContributionsProvider =
    FutureProvider.family<List<ContributionModel>, String>((ref, goalId) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getContributions(goalId);
});

// Goal Progress Provider
final goalProgressProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, goalId) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getProgress(goalId);
});
