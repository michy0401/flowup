// lib/features/investments/presentation/widgets/investment_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowup/core/theme/app_colors.dart';

class InvestmentCard extends StatelessWidget {
  final String investmentId;
  final String title;
  final String description;
  final String status;
  final String timeframe;
  final double initialAmount;
  final double currentValue;
  final double percentageChange;
  final bool isNegative;

  const InvestmentCard({
    super.key,
    required this.investmentId,
    required this.title,
    required this.description,
    required this.status,
    required this.timeframe,
    required this.initialAmount,
    required this.currentValue,
    required this.percentageChange,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final Color performanceColor =
        isNegative ? AppColors.redError : AppColors.greenSuccess;
    final IconData performanceIcon =
        isNegative ? Icons.arrow_downward : Icons.arrow_upward;

    return Card(
      child: InkWell(
        onTap: () {
          // Navegar al detalle
          context.push('/investments/$investmentId');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Fila Superior: Título, Descripción y Rendimiento ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.image_outlined, size: 40),
                title: Text(title, style: textTheme.titleMedium),
                subtitle: Text(description, style: textTheme.bodySmall),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${percentageChange.toStringAsFixed(2)}%',
                      style: textTheme.titleSmall
                          ?.copyWith(color: performanceColor),
                    ),
                    Icon(performanceIcon, color: performanceColor, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- Fila Media: Estado y Plazo ---
              Row(
                children: [
                  Chip(
                    label: Text(status),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
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
              const Divider(),
              const SizedBox(height: 8),

              // --- Fila Inferior: Montos ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AmountColumn(
                    title: 'Inversión Inicial',
                    amount: initialAmount,
                  ),
                  _AmountColumn(
                    title: 'Valor Total Invertido',
                    amount: currentValue,
                    color: performanceColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper para las columnas de montos
class _AmountColumn extends StatelessWidget {
  final String title;
  final double amount;
  final Color? color;

  const _AmountColumn({
    required this.title,
    required this.amount,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}