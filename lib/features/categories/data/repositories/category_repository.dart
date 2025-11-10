// lib/features/categories/data/repositories/category_repository.dart
import '../datasources/category_remote_datasource.dart';
import '../../domain/models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository({required CategoryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<CategoryModel>> getAll({String? query, String? scope}) =>
      _remoteDataSource.getAll(query: query, scope: scope);

  Future<CategoryModel> getById(String id) => _remoteDataSource.getById(id);

  Future<CategoryModel> create({
    required String name,
    required String scope,
    String? color,
    String? icon,
  }) =>
      _remoteDataSource.create(
        name: name,
        scope: scope,
        color: color,
        icon: icon,
      );

  Future<CategoryModel> update(
    String id, {
    String? name,
    String? scope,
    String? color,
    String? icon,
  }) =>
      _remoteDataSource.update(
        id,
        name: name,
        scope: scope,
        color: color,
        icon: icon,
      );

  Future<void> delete(String id) => _remoteDataSource.delete(id);
}
