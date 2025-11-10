// lib/features/home/presentation/widgets/transaction_list_tile.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart'; // <-- 1. AÑADE IMPORTACIÓN

class TransactionListTile extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String amount;
  final bool isExpense;

  const TransactionListTile({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = isExpense ? AppColors.redError : AppColors.greenSuccess;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: const Icon(Icons.shopping_cart_outlined), // Icono de placeholder
        ),
        title: Text(title, style: textTheme.titleMedium),
        subtitle: Text(
          '$category · $date',
          style: textTheme.bodySmall,
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'}\$$amount',
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        // --- 2. ACTUALIZA EL ONTAP ---
        onTap: () {
          // (Usamos un ID de prueba por ahora)
          // Cuando tengamos datos reales, usaremos el ID de la transacción
          final fakeTransactionId = '123'; 

          if (isExpense) {
            // context.push('/expenses/$fakeTransactionId');
          } else {
            // Navega a la pantalla de detalle de ingreso
            context.push('/income/$fakeTransactionId');
          }
        },
      ),
    );
  }
}