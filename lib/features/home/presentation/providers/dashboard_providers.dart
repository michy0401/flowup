// lib/features/home/presentation/providers/dashboard_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/models/dashboard_summary_model.dart';
import '../../domain/models/chart_data_model.dart';

// Data Source Provider
final dashboardRemoteDataSourceProvider =
    Provider<DashboardRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRemoteDataSource(apiClient: apiClient);
});

// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final remoteDataSource = ref.watch(dashboardRemoteDataSourceProvider);
  return DashboardRepository(remoteDataSource: remoteDataSource);
});

// Dashboard Summary Provider
final dashboardSummaryProvider =
    FutureProvider<DashboardSummaryModel>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getSummary();
});

// Dashboard Chart Data Provider
final dashboardChartDataProvider = FutureProvider<ChartDataModel>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getChartData();
});
