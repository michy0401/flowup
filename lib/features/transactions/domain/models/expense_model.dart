// lib/features/transactions/domain/models/expense_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  final String id;
  final String amount;
  final String? currency;
  final String? category;
  final String? description;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.id,
    required this.amount,
    this.currency,
    this.category,
    this.description,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
