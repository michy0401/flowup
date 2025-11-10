// lib/features/savings/domain/models/goal_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'goal_model.g.dart';

@JsonSerializable()
class GoalModel {
  final String id;
  final String title;
  final String targetAmount;
  final String? currentAmount;
  final DateTime? deadline;
  final String status; // 'ACTIVE', 'COMPLETED', 'PAUSED'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount,
    this.deadline,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalModelToJson(this);

  double get targetAmountAsDouble => double.tryParse(targetAmount) ?? 0.0;
  double get currentAmountAsDouble => double.tryParse(currentAmount ?? '0') ?? 0.0;

  double get progressPercentage {
    if (targetAmountAsDouble == 0) return 0.0;
    return (currentAmountAsDouble / targetAmountAsDouble) * 100;
  }

  bool get isActive => status == 'ACTIVE';
  bool get isCompleted => status == 'COMPLETED';
  bool get isPaused => status == 'PAUSED';
}
