// lib/features/transactions/presentation/screens/expense_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final String transactionId;

  const ExpenseDetailScreen({
    super.key,
    required this.transactionId, // Recibe el ID de la ruta
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
                Text('¿Estás seguro de que deseas eliminar este gasto?'),
                Text('Esta acción no se puede deshacer.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text(
                'Eliminar',
                style: TextStyle(color: AppColors.redError),
              ),
              onPressed: () {
                // Lógica de borrado de Riverpod iría aquí
                print('Gasto $transactionId eliminado');
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
                context.pop(); // Regresa a la pantalla anterior
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

    // --- (Datos de prueba - En el futuro, esto vendría de un Provider) ---
    final transaction = {
      'id': transactionId,
      'amount': '120.00',
      'concept': 'Compra en Supermercado',
      'category': 'Comida',
      'paymentMethod': 'Tarjeta de Débito',
      'date': '08/11/2025',
    };
    // ------------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GASTO', // <-- Título cambiado
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
          // --- 1. Tarjeta de Monto ---
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
                      color: AppColors.redError, // <-- Color cambiado
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- 2. Tarjeta de Detalles ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLE DE GASTO', // <-- Título cambiado
                    style: textTheme.labelMedium,
                  ),
                  const Divider(height: 24),
                  
                  // Campos de detalle actualizados
                  _DetailRow(
                    title: 'Concepto',
                    subtitle: transaction['concept']!,
                  ),
                  _DetailRow(
                    title: 'Categoria',
                    subtitle: transaction['category']!,
                  ),
                  _DetailRow(
                    title: 'Metodo de Pago', // <-- Campo cambiado
                    subtitle: transaction['paymentMethod']!,
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

          // --- 3. Botones de Acción ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Editar
              FloatingActionButton(
                onPressed: () {
                  // NAVEGA AL FORMULARIO Y PASA LOS DATOS
                  context.push('/expenses/new', extra: transaction);
                },
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              // Botón Borrar
              FloatingActionButton(
                onPressed: () {
                  // LLAMA AL DIÁLOGO DE CONFIRMACIÓN
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

// --- Helper Widget para las filas de detalle ---
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