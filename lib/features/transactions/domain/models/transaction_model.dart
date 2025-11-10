// lib/features/transactions/domain/models/transaction_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final String type; // 'income' or 'expense'
  final String amount;
  final String? currency;
  final String? category;
  final String? description;
  @JsonKey(name: 'isRecurring')
  final bool? isRecurring;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.currency,
    this.category,
    this.description,
    this.isRecurring,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
