// lib/features/home/presentation/widgets/summary_card.dart
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback onTap;
  final Color? color; // Opcional, para dar color (ej. verde a ingresos)

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      // Usamos el color de la tarjeta del tema
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textTheme.bodySmall?.color, // Color grisáceo
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? textTheme.titleLarge?.color, // Color opcional
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}