// lib/features/transactions/domain/models/income_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'income_model.g.dart';

@JsonSerializable()
class IncomeModel {
  final String id;
  final String amount;
  final String? currency;
  final String? category;
  final String? description;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncomeModel({
    required this.id,
    required this.amount,
    this.currency,
    this.category,
    this.description,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeModelToJson(this);

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
