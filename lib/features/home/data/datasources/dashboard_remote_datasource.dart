// lib/features/home/data/datasources/dashboard_remote_datasource.dart
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/models/dashboard_summary_model.dart';
import '../../domain/models/chart_data_model.dart';

class DashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Obtener resumen financiero
  Future<DashboardSummaryModel> getSummary() async {
    final response = await _apiClient.get(ApiConstants.dashboardSummary);
    return DashboardSummaryModel.fromJson(response.data);
  }

  /// Obtener datos para gráficos (últimos 30 días)
  Future<ChartDataModel> getChartData() async {
    final response = await _apiClient.get(ApiConstants.dashboardChartData);
    return ChartDataModel.fromJson(response.data);
  }
}
