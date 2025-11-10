// lib/features/savings/presentation/widgets/saving_goal_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowup/core/theme/app_colors.dart';

class SavingGoalCard extends StatelessWidget {
  final String goalId;
  final String title;
  final String description;
  final String status;
  final String timeframe;
  final double currentAmount;
  final double targetAmount;
  final double monthlyContribution;
  final bool isCompleted;

  const SavingGoalCard({
    super.key,
    required this.goalId,
    required this.title,
    required this.description,
    required this.status,
    required this.timeframe,
    required this.currentAmount,
    required this.targetAmount,
    required this.monthlyContribution,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double progress = (currentAmount / targetAmount).clamp(0.0, 1.0);
    final double remainingAmount = targetAmount - currentAmount;

    return Card(
      child: InkWell(
        onTap: () {
          // Navegar al detalle
          context.push('/savings/$goalId');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fila Superior: Título, Descripción y Estado ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.image_outlined, size: 40),
                title: Text(title, style: textTheme.titleMedium),
                subtitle: Text(description, style: textTheme.bodySmall),
                trailing: Text(
                  isCompleted ? 'Completado' : 'Activo',
                  style: textTheme.bodySmall?.copyWith(
                    color: isCompleted ? AppColors.greenSuccess : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Fila Media: Estado y Plazo ---
              Row(
                children: [
                  Chip(
                    label: Text(status),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(timeframe, style: textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 16),

              // --- Fila de Progreso ---
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: AppColors.greenSuccess,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),

              // --- Fila de Montos ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$currentAmount de \$$targetAmount',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$$monthlyContribution / Mes',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // --- Fila Inferior: Restante y Estado ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$remainingAmount Restante',
                    style: textTheme.bodySmall,
                  ),
                  Text(status, style: textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}