// lib/features/home/domain/models/dashboard_summary_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary_model.g.dart';

@JsonSerializable()
class DashboardSummaryModel {
  final String income;
  final String expenses;
  final String balance;

  DashboardSummaryModel({
    required this.income,
    required this.expenses,
    required this.balance,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);

  double get incomeAsDouble => double.tryParse(income) ?? 0.0;
  double get expensesAsDouble => double.tryParse(expenses) ?? 0.0;
  double get balanceAsDouble => double.tryParse(balance) ?? 0.0;
}
