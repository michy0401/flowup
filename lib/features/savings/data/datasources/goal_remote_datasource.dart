// lib/features/savings/data/datasources/goal_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/models/contribution_model.dart';

class GoalRemoteDataSource {
  final ApiClient _apiClient;

  GoalRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtener todas las metas de ahorro
  Future<List<GoalModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.ahorros);
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => GoalModel.fromJson(json)).toList();
  }

  /// Obtener meta por ID
  Future<GoalModel> getById(String id) async {
    final response = await _apiClient.get('${ApiConstants.ahorros}/$id');
    return GoalModel.fromJson(response.data);
  }

  /// Crear nueva meta de ahorro
  Future<GoalModel> create({
    required String title,
    required String targetAmount,
    DateTime? deadline,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'targetAmount': targetAmount,
    };
    if (deadline != null) body['deadline'] = deadline.toIso8601String();

    final response = await _apiClient.post(ApiConstants.ahorros, body: body);
    return GoalModel.fromJson(response.data);
  }

  /// Actualizar meta de ahorro
  Future<GoalModel> update(
    String id, {
    String? title,
    String? targetAmount,
    DateTime? deadline,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (targetAmount != null) body['targetAmount'] = targetAmount;
    if (deadline != null) body['deadline'] = deadline.toIso8601String();

    final response =
        await _apiClient.put('${ApiConstants.ahorros}/$id', body: body);
    return GoalModel.fromJson(response.data);
  }

  /// Eliminar meta de ahorro
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiConstants.ahorros}/$id');
  }

  /// Agregar contribución a meta
  Future<ContributionModel> addContribution({
    required String goalId,
    required String amount,
    DateTime? date,
    String? description,
    String? category,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
    };
    if (date != null) body['date'] = date.toIso8601String();
    if (description != null) body['description'] = description;
    if (category != null) body['category'] = category;

    final response = await _apiClient.post(
      '${ApiConstants.ahorros}/$goalId/contribuciones',
      body: body,
    );
    return ContributionModel.fromJson(response.data);
  }

  /// Obtener contribuciones de una meta
  Future<List<ContributionModel>> getContributions(String goalId) async {
    final response = await _apiClient.get(
      '${ApiConstants.ahorros}/$goalId/contribuciones',
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => ContributionModel.fromJson(json)).toList();
  }

  /// Obtener progreso de una meta
  Future<Map<String, dynamic>> getProgress(String goalId) async {
    final response = await _apiClient.get(
      '${ApiConstants.ahorros}/$goalId/progreso',
    );
    return response.data as Map<String, dynamic>;
  }
}
