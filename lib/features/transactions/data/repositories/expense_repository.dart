// lib/features/transactions/data/repositories/expense_repository.dart
import '../datasources/expense_remote_datasource.dart';
import '../../domain/models/expense_model.dart';

class ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepository({required ExpenseRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<ExpenseModel>> getAll({
    String? query,
    String? category,
    int? skip,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) =>
      _remoteDataSource.getAll(
        query: query,
        category: category,
        skip: skip,
        limit: limit,
        from: from,
        to: to,
      );

  Future<List<ExpenseModel>> search(String query) =>
      _remoteDataSource.search(query);

  Future<String> getTotal({DateTime? from, DateTime? to}) =>
      _remoteDataSource.getTotal(from: from, to: to);

  Future<ExpenseModel> getById(String id) => _remoteDataSource.getById(id);

  Future<ExpenseModel> create({
    required String amount,
    String? currency,
    String? category,
    String? description,
    DateTime? date,
  }) =>
      _remoteDataSource.create(
        amount: amount,
        currency: currency,
        category: category,
        description: description,
        date: date,
      );

  Future<ExpenseModel> update(
    String id, {
    String? amount,
    String? currency,
    String? category,
    String? description,
    DateTime? date,
  }) =>
      _remoteDataSource.update(
        id,
        amount: amount,
        currency: currency,
        category: category,
        description: description,
        date: date,
      );

  Future<void> delete(String id) => _remoteDataSource.delete(id);
}
