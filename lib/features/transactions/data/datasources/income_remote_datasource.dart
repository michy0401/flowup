// lib/features/transactions/data/datasources/income_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/income_model.dart';

class IncomeRemoteDataSource {
  final ApiClient _apiClient;

  IncomeRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtener todos los ingresos
  Future<List<IncomeModel>> getAll({
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
      ApiConstants.ingresos,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => IncomeModel.fromJson(json)).toList();
  }

  /// Buscar ingresos
  Future<List<IncomeModel>> search(String query) async {
    final response = await _apiClient.get(
      ApiConstants.ingresosSearch,
      queryParameters: {'query': query},
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => IncomeModel.fromJson(json)).toList();
  }

  /// Obtener total de ingresos
  Future<String> getTotal({DateTime? from, DateTime? to}) async {
    final queryParams = <String, dynamic>{};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final response = await _apiClient.get(
      ApiConstants.ingresosTotal,
      queryParameters: queryParams,
    );

    return response.data['total']?.toString() ?? '0';
  }

  /// Obtener ingreso por ID
  Future<IncomeModel> getById(String id) async {
    final response = await _apiClient.get('${ApiConstants.ingresos}/$id');
    return IncomeModel.fromJson(response.data);
  }

  /// Crear nuevo ingreso
  Future<IncomeModel> create({
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
      ApiConstants.ingresos,
      body: body,
    );

    return IncomeModel.fromJson(response.data);
  }

  /// Actualizar ingreso
  Future<IncomeModel> update(
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
      '${ApiConstants.ingresos}/$id',
      body: body,
    );

    return IncomeModel.fromJson(response.data);
  }

  /// Eliminar ingreso
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiConstants.ingresos}/$id');
  }
}
