// lib/features/transactions/presentation/screens/income_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class IncomeDetailScreen extends StatelessWidget {
  final String transactionId;

  const IncomeDetailScreen({
    super.key,
    required this.transactionId,
  });

  // --- MÉTODO PARA EL DIÁLOGO DE BORRADO ---
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que deseas eliminar este ingreso?'),
                Text('Esta acción no se puede deshacer.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(color: AppColors.redError),
              ),
              onPressed: () {
                print('Ingreso $transactionId eliminado');
                Navigator.of(dialogContext).pop();
                context.pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    // --- (Datos de prueba) ---
    final transaction = {
      'id': transactionId,
      'amount': '1,500.00',
      'concept': 'Pago de Salario',
      'category': 'Salario',
      'origin': 'Mi Empresa S.A.',
      'date': '07/11/2025',
    };
    // -------------------------

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INGRESO',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // --- 1. Tarjeta de Monto (CÓDIGO RESTAURADO) ---
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.image_outlined, // Placeholder del icono
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${transaction['amount']}',
                    style: textTheme.displaySmall?.copyWith(
                      color: AppColors.greenSuccess,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- 2. Tarjeta de Detalles (CÓDIGO RESTAURADO) ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLE DE INGRESO',
                    style: textTheme.labelMedium,
                  ),
                  const Divider(height: 24),
                  
                  // Usamos el widget helper
                  _DetailRow(
                    title: 'Concepto',
                    subtitle: transaction['concept']!,
                  ),
                  _DetailRow(
                    title: 'Categoria',
                    subtitle: transaction['category']!,
                  ),
                  _DetailRow(
                    title: 'Origen',
                    subtitle: transaction['origin']!,
                  ),
                  _DetailRow(
                    title: 'Fecha',
                    subtitle: transaction['date']!,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- 3. Botones de Acción (Tu código está correcto) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  context.push('/income/new', extra: transaction);
                },
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              FloatingActionButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                backgroundColor: AppColors.redError,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// --- Helper Widget (CÓDIGO RESTAURADO) ---
// (Esta es la versión que coincide con el código de la tarjeta de detalles)
class _DetailRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _DetailRow({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}