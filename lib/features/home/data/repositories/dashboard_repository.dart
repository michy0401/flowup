// lib/features/home/data/repositories/dashboard_repository.dart
import '../datasources/dashboard_remote_datasource.dart';
import '../../domain/models/dashboard_summary_model.dart';
import '../../domain/models/chart_data_model.dart';

class DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepository({required DashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<DashboardSummaryModel> getSummary() => _remoteDataSource.getSummary();

  Future<ChartDataModel> getChartData() => _remoteDataSource.getChartData();
}
