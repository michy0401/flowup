// lib/features/savings/data/repositories/goal_repository.dart
import '../datasources/goal_remote_datasource.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/models/contribution_model.dart';

class GoalRepository {
  final GoalRemoteDataSource _remoteDataSource;

  GoalRepository({required GoalRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<GoalModel>> getAll() => _remoteDataSource.getAll();

  Future<GoalModel> getById(String id) => _remoteDataSource.getById(id);

  Future<GoalModel> create({
    required String title,
    required String targetAmount,
    DateTime? deadline,
  }) =>
      _remoteDataSource.create(
        title: title,
        targetAmount: targetAmount,
        deadline: deadline,
      );

  Future<GoalModel> update(
    String id, {
    String? title,
    String? targetAmount,
    DateTime? deadline,
  }) =>
      _remoteDataSource.update(
        id,
        title: title,
        targetAmount: targetAmount,
        deadline: deadline,
      );

  Future<void> delete(String id) => _remoteDataSource.delete(id);

  Future<ContributionModel> addContribution({
    required String goalId,
    required String amount,
    DateTime? date,
    String? description,
    String? category,
  }) =>
      _remoteDataSource.addContribution(
        goalId: goalId,
        amount: amount,
        date: date,
        description: description,
        category: category,
      );

  Future<List<ContributionModel>> getContributions(String goalId) =>
      _remoteDataSource.getContributions(goalId);

  Future<Map<String, dynamic>> getProgress(String goalId) =>
      _remoteDataSource.getProgress(goalId);
}
