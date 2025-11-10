// lib/features/categories/data/datasources/category_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtener todas las categorías
  Future<List<CategoryModel>> getAll({
    String? query,
    String? scope,
  }) async {
    final queryParams = <String, dynamic>{};
    if (query != null) queryParams['q'] = query;
    if (scope != null) queryParams['scope'] = scope;

    final response = await _apiClient.get(
      ApiConstants.categorias,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  /// Obtener categoría por ID
  Future<CategoryModel> getById(String id) async {
    final response = await _apiClient.get('${ApiConstants.categorias}/$id');
    return CategoryModel.fromJson(response.data);
  }

  /// Crear nueva categoría
  Future<CategoryModel> create({
    required String name,
    required String scope,
    String? color,
    String? icon,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'scope': scope,
    };
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;

    final response = await _apiClient.post(
      ApiConstants.categorias,
      body: body,
    );

    return CategoryModel.fromJson(response.data);
  }

  /// Actualizar categoría
  Future<CategoryModel> update(
    String id, {
    String? name,
    String? scope,
    String? color,
    String? icon,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (scope != null) body['scope'] = scope;
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;

    final response = await _apiClient.put(
      '${ApiConstants.categorias}/$id',
      body: body,
    );

    return CategoryModel.fromJson(response.data);
  }

  /// Eliminar categoría
  Future<void> delete(String id) async {
    await _apiClient.delete('${ApiConstants.categorias}/$id');
  }
}
