// lib/features/transactions/data/datasources/expense_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/expense_model.dart';

class ExpenseRemoteDataSource {
  final ApiClient _apiClient;

  ExpenseRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtener todos los gastos
  Future<List<ExpenseModel>> getAll({
    String? query,
    String? category,
    int? skip,
    int? limit,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{};
    if (query != null) queryParams['q'] = query;
    if (category != null) queryParams['category'] = category;
    if (skip != null) queryParams['skip'] = skip.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final response = await _apiClient.get(
      ApiConstants.gastos,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  /// Buscar gastos
  Future<List<ExpenseModel>> search(String query) async {
    final response = await _apiClient.get(
      ApiConstants.gastosSearch,
      queryParameters: {'query': query},
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ExpenseModel.fromJson(json)).toList();
  }

  /// Obtener total de gastos
  Future<String> getTotal({DateTime? from, DateTime? to}) async {
    final queryParams = <String, dynamic>{};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final response = await _apiClient.get(
      ApiConstants.gastosTotal,
      queryParameters: queryParams,
    );

    return response.data['total']?.toString() ?? '0';
  }

  /// Obtener gasto por ID
  Future<ExpenseModel> getById(String id) async {
    final response = await _apiClient.get('${ApiConstants.gastos}/$id');
    return ExpenseModel.fromJson(response.data);
  }

  /// Crear nuevo gasto
  Future<ExpenseModel> create({
    required String amount,
    String? currency,
    String? category,
    String? description,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
    };
    if (currency != null) body['currency'] = currency;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await _apiClient.post(
      ApiConstants.gastos,
      body: body,
    );

    return ExpenseModel.fromJson(response.data);
  }

  /// Actualizar gasto
  Future<ExpenseModel> update(
    String id, {
    String? amount,
    String? currency,
    String? category,
    String? description,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null) body['amount'] = amount;
    if (currency != null) body['currency'] = currency;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await _apiClient.put(
      '${ApiConstants.gastos}/$id',
      body: body,
    );

    return ExpenseModel.fromJson(response.data);
  }

  /// Eliminar gasto
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiConstants.gastos}/$id');
  }
}
