// lib/features/investments/domain/models/investment_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'investment_model.g.dart';

@JsonSerializable()
class InvestmentModel {
  final String id;
  final String amount;
  final String? currency;
  final String? category;
  final String? description;
  final String? broker;
  final String? instrument;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvestmentModel({
    required this.id,
    required this.amount,
    this.currency,
    this.category,
    this.description,
    this.broker,
    this.instrument,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvestmentModelToJson(this);

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
