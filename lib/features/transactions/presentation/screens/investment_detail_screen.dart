// lib/features/transactions/presentation/screens/investment_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class InvestmentDetailScreen extends StatelessWidget {
  final String investmentId;

  const InvestmentDetailScreen({
    super.key,
    required this.investmentId, // Recibe el ID de la ruta
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
                Text('¿Estás seguro de que deseas eliminar esta inversión?'),
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
                print('Inversión $investmentId eliminada');
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
    // Usamos los mismos datos que en la lista y el formulario
    final investment = {
      'id': investmentId,
      'name': 'Acciones de Tesla (TSLA)',
      'date': '01/01/2025',
      'amount': '1000.00',
      'fees': '15.00',
      'concept': 'Inversión inicial en acciones de TSLA',
      'category': 'Acciones',
      'currency': 'USD',
      // Datos extra para esta pantalla
      'currentValue': '1200.00',
      'monthlyContribution': '50.00', // (Dato de ejemplo)
    };
    // ------------------------------------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INVERSION',
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
          // --- 1. Tarjeta de Resumen ---
          _buildSummaryCard(context, investment),
          const SizedBox(height: 24),

          // --- 2. Tarjeta de Detalles ---
          _buildDetailsCard(context, investment),
          const SizedBox(height: 24),

          // --- 3. Tarjeta de Contribuciones ---
          _buildContributionsCard(context),
          const SizedBox(height: 24),

          // --- 4. Botones de Acción ---
          // (Ignoramos la posición de los botones en el mockup
          // para mantener la consistencia con las otras pantallas de detalle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Editar
              FloatingActionButton(
                onPressed: () {
                  // NAVEGA AL FORMULARIO Y PASA LOS DATOS
                  context.push('/investments/new', extra: investment);
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

  // --- Helper: Tarjeta de Resumen ---
  Widget _buildSummaryCard(BuildContext context, Map<String, dynamic> investment) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
              title: Text(
                investment['name']!,
                style: textTheme.titleLarge,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailColumn(
                  title: 'Inversión Inicial',
                  subtitle: '\$${investment['amount']!}',
                ),
                _DetailColumn(
                  title: 'Aporte / Mes',
                  subtitle: '\$${investment['monthlyContribution']!}',
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DetailColumn(
                  title: 'Total Invertido',
                  subtitle: '\$${investment['currentValue']!}',
                ),
                _DetailColumn(
                  title: 'Divisa',
                  subtitle: investment['currency']!,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Tarjeta de Detalles ---
  Widget _buildDetailsCard(BuildContext context, Map<String, dynamic> investment) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETALLE DE INVERSION',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            _DetailRow(
              title: 'Categoria',
              subtitle: investment['category']!,
            ),
            _DetailRow(
              title: 'Monto Inversión',
              subtitle: '\$${investment['amount']!}',
            ),
            _DetailRow(
              title: 'Comisiones',
              subtitle: '\$${investment['fees']!}',
            ),
            _DetailRow(
              title: 'Concepto',
              subtitle: investment['concept']!,
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Tarjeta de Contribuciones ---
  Widget _buildContributionsCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONTRIBUCIONES RECIENTES',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            // (Datos de prueba para contribuciones)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aporte mensual'),
              subtitle: const Text('01/11/2025'),
              trailing: Text(
                '+\$50.00',
                style: textTheme.titleSmall?.copyWith(color: AppColors.greenSuccess),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aporte mensual'),
              subtitle: const Text('01/10/2025'),
              trailing: Text(
                '+\$50.00',
                style: textTheme.titleSmall?.copyWith(color: AppColors.greenSuccess),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widget para las filas de detalle (Tarjeta 2) ---
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

// --- Helper Widget para las columnas de detalle (Tarjeta 1) ---
class _DetailColumn extends StatelessWidget {
  final String title;
  final String subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  const _DetailColumn({
    required this.title,
    required this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}