// lib/features/transactions/presentation/screens/saving_goal_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SavingGoalDetailScreen extends StatelessWidget {
  final String goalId;

  const SavingGoalDetailScreen({
    super.key,
    required this.goalId, // Recibe el ID de la ruta
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
                Text('¿Estás seguro de que deseas eliminar esta meta de ahorro?'),
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
                print('Meta de Ahorro $goalId eliminada');
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
    final goal = {
      'id': goalId,
      'concept': 'Viaje a Japón',
      'category': 'Viajes',
      'targetAmount': '5000.00',
      'monthlyContribution': '160.00',
      'startDate': '01/01/2025',
      'endDate': '01/01/2027',
      // Datos de progreso
      'currentAmount': '1200.00',
      'status': 'Activo',
    };
    // ------------------------------------------------------------------

    // Cálculos para la barra de progreso
    final double current = double.tryParse(goal['currentAmount']!) ?? 0.0;
    final double target = double.tryParse(goal['targetAmount']!) ?? 0.0;
    final double progress = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;
    final double remaining = target - current;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AHORRO',
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
          // --- 1. Tarjeta de Progreso ---
          _buildProgressCard(context, goal, progress, current, target, remaining),
          const SizedBox(height: 24),

          // --- 2. Tarjeta de Detalles ---
          _buildDetailsCard(context, goal),
          const SizedBox(height: 24),

          // --- 3. Tarjeta de Contribuciones ---
          _buildContributionsCard(context),
          const SizedBox(height: 24),

          // --- 4. Botones de Acción ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Editar
              FloatingActionButton(
                onPressed: () {
                  // NAVEGA AL FORMULARIO Y PASA LOS DATOS
                  context.push('/savings/new', extra: goal);
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

  // --- Helper: Tarjeta de Progreso ---
  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> goal,
      double progress, double current, double target, double remaining) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono y Categoría
            Row(
              children: [
                const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                const SizedBox(width: 16),
                Text(
                  goal['category']!,
                  style: textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%', // Porcentaje
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.greenSuccess,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Barra de Progreso
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: AppColors.greenSuccess,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),

            // Textos de Progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$current de \$$target',
                  style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$$remaining Restante',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  goal['status']!,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Tarjeta de Detalles ---
  Widget _buildDetailsCard(BuildContext context, Map<String, dynamic> goal) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETALLE DE AHORRO',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            _DetailRow(
              title: 'Concepto',
              subtitle: goal['concept']!,
            ),
            _DetailRow(
              title: 'Monto Mensual',
              subtitle: '\$${goal['monthlyContribution']!}',
            ),
            _DetailRow(
              title: 'Meta a Ahorrar',
              subtitle: '\$${goal['targetAmount']!}',
            ),
            _DetailRow(
              title: 'Fecha Limite',
              subtitle: goal['endDate']!,
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
              title: const Text('Aporte Mensual'),
              subtitle: const Text('01/11/2025'),
              trailing: Text(
                '+\$160.00',
                style: textTheme.titleSmall?.copyWith(color: AppColors.greenSuccess),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aporte Mensual'),
              subtitle: const Text('01/10/2025'),
              trailing: Text(
                '+\$160.00',
                style: textTheme.titleSmall?.copyWith(color: AppColors.greenSuccess),
              ),
            ),
            // (Los botones de editar/borrar del mockup están aquí,
            // pero los hemos movido afuera para que apliquen a toda la meta)
          ],
        ),
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