// lib/features/home/domain/models/chart_data_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'chart_data_model.g.dart';

@JsonSerializable()
class ChartDataModel {
  final List<String> labels;
  final List<double> income;
  final List<double> expenses;

  ChartDataModel({
    required this.labels,
    required this.income,
    required this.expenses,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) =>
      _$ChartDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataModelToJson(this);
}
