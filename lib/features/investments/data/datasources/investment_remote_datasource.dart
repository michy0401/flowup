// lib/features/investments/data/datasources/investment_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/investment_model.dart';

class InvestmentRemoteDataSource {
  final ApiClient _apiClient;

  InvestmentRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtener todas las inversiones
  Future<List<InvestmentModel>> getAll({
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
      ApiConstants.inversiones,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => InvestmentModel.fromJson(json)).toList();
  }

  /// Buscar inversiones
  Future<List<InvestmentModel>> search(String query) async {
    final response = await _apiClient.get(
      ApiConstants.inversionesSearch,
      queryParameters: {'query': query},
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => InvestmentModel.fromJson(json)).toList();
  }

  /// Obtener total de inversiones
  Future<String> getTotal({DateTime? from, DateTime? to}) async {
    final queryParams = <String, dynamic>{};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final response = await _apiClient.get(
      ApiConstants.inversionesTotal,
      queryParameters: queryParams,
    );

    return response.data['total']?.toString() ?? '0';
  }

  /// Obtener inversión por ID
  Future<InvestmentModel> getById(String id) async {
    final response = await _apiClient.get('${ApiConstants.inversiones}/$id');
    return InvestmentModel.fromJson(response.data);
  }

  /// Crear nueva inversión
  Future<InvestmentModel> create({
    required String amount,
    String? currency,
    String? category,
    String? description,
    String? broker,
    String? instrument,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
    };
    if (currency != null) body['currency'] = currency;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (broker != null) body['broker'] = broker;
    if (instrument != null) body['instrument'] = instrument;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await _apiClient.post(
      ApiConstants.inversiones,
      body: body,
    );

    return InvestmentModel.fromJson(response.data);
  }

  /// Actualizar inversión
  Future<InvestmentModel> update(
    String id, {
    String? amount,
    String? currency,
    String? category,
    String? description,
    String? broker,
    String? instrument,
    DateTime? date,
  }) async {
    final body = <String, dynamic>{};
    if (amount != null) body['amount'] = amount;
    if (currency != null) body['currency'] = currency;
    if (category != null) body['category'] = category;
    if (description != null) body['description'] = description;
    if (broker != null) body['broker'] = broker;
    if (instrument != null) body['instrument'] = instrument;
    if (date != null) body['date'] = date.toIso8601String();

    final response = await _apiClient.put(
      '${ApiConstants.inversiones}/$id',
      body: body,
    );

    return InvestmentModel.fromJson(response.data);
  }

  /// Eliminar inversión
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiConstants.inversiones}/$id');
  }
}
