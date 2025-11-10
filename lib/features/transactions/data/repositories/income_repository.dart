// lib/features/transactions/data/repositories/income_repository.dart
import '../datasources/income_remote_datasource.dart';
import '../../domain/models/income_model.dart';

class IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepository({required IncomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<IncomeModel>> getAll({
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

  Future<List<IncomeModel>> search(String query) =>
      _remoteDataSource.search(query);

  Future<String> getTotal({DateTime? from, DateTime? to}) =>
      _remoteDataSource.getTotal(from: from, to: to);

  Future<IncomeModel> getById(String id) => _remoteDataSource.getById(id);

  Future<IncomeModel> create({
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

  Future<IncomeModel> update(
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
