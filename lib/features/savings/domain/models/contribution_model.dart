// lib/features/savings/domain/models/contribution_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'contribution_model.g.dart';

@JsonSerializable()
class ContributionModel {
  final String id;
  final String amount;
  final String? notes;
  final String? description;
  final String? category;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContributionModel({
    required this.id,
    required this.amount,
    this.notes,
    this.description,
    this.category,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory ContributionModel.fromJson(Map<String, dynamic> json) =>
      _$ContributionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContributionModelToJson(this);

  double get amountAsDouble => double.tryParse(amount) ?? 0.0;
}
