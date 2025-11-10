// lib/features/investments/data/repositories/investment_repository.dart
import '../datasources/investment_remote_datasource.dart';
import '../../domain/models/investment_model.dart';

class InvestmentRepository {
  final InvestmentRemoteDataSource _remoteDataSource;

  InvestmentRepository({required InvestmentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<InvestmentModel>> getAll({
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

  Future<List<InvestmentModel>> search(String query) =>
      _remoteDataSource.search(query);

  Future<String> getTotal({DateTime? from, DateTime? to}) =>
      _remoteDataSource.getTotal(from: from, to: to);

  Future<InvestmentModel> getById(String id) => _remoteDataSource.getById(id);

  Future<InvestmentModel> create({
    required String amount,
    String? currency,
    String? category,
    String? description,
    String? broker,
    String? instrument,
    DateTime? date,
  }) =>
      _remoteDataSource.create(
        amount: amount,
        currency: currency,
        category: category,
        description: description,
        broker: broker,
        instrument: instrument,
        date: date,
      );

  Future<InvestmentModel> update(
    String id, {
    String? amount,
    String? currency,
    String? category,
    String? description,
    String? broker,
    String? instrument,
    DateTime? date,
  }) =>
      _remoteDataSource.update(
        id,
        amount: amount,
        currency: currency,
        category: category,
        description: description,
        broker: broker,
        instrument: instrument,
        date: date,
      );

  Future<void> delete(String id) => _remoteDataSource.delete(id);
}
