import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:proyecto_final_01/main.dart';
import 'package:proyecto_final_01/incomes_screen.dart'; 

class IncomeDetail {
  final String id;
  final String category;
  final String description;
  final double amount;
  final String dateString;
  final String time;
  final String? notes;
  final String? source;
  final String paymentMethod;

  IncomeDetail({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.dateString,
    required this.time,
    this.notes,
    this.source,
    required this.paymentMethod,
  });
}

class IncomeDetailScreen extends StatelessWidget {
  final String incomeId;

  const IncomeDetailScreen({super.key, required this.incomeId});

  IncomeDetail? _getMockIncome() {
    final income = mockIncomes.firstWhereOrNull((inc) => inc.id == incomeId);

    if (income == null) return null;

    return IncomeDetail(
      id: income.id,
      category: income.category,
      description: income.description,
      amount: income.amount,
      dateString: DateFormat('yyyy-MM-dd').format(income.date),
      time: DateFormat('HH:mm').format(income.date),
      notes: income.notes,
      source: income.source,
      paymentMethod: "Transferencia Bancaria", 
    );
  }

  String _formatDate(String dateString) {
    Intl.defaultLocale = 'es_ES';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'es_ES').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _handleDelete(BuildContext context, String id) {
    print("Eliminando ingreso: $id");
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final income = _getMockIncome(); 

    if (income == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('No se encontró el ingreso.', style: theme.textTheme.bodyLarge)),
      );
    }
    
    final Color primaryColor = successGreen;
    final IconData typeIcon = getIncomeCategoryIconData(income.category);
    const String typeLabel = 'Ingreso';
    const String amountSign = '+';
    final String amountText = NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(income.amount);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, income, primaryColor, _handleDelete),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildAmountCard(context, income, primaryColor, typeIcon, amountText, amountSign, typeLabel),
            const SizedBox(height: 16),

            _buildDetailsCard(context, income, _formatDate),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, IncomeDetail income, Color color, Function(BuildContext, String) onDelete) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: theme.appBarTheme.foregroundColor),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Detalle del Ingreso',
        style: theme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.edit, color: color, size: 20),
          onPressed: () {
            print('Navegar a Editar Ingreso ${income.id}');
          },
        ),
        IconButton(
          icon: const Icon(LucideIcons.trash2, color: destructiveRed, size: 20),
          onPressed: () => _showDeleteConfirmation(context, income.id, onDelete),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, Function(BuildContext, String) onDelete) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(LucideIcons.alertTriangle, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text('Eliminar Ingreso', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text('¿Estás seguro de que quieres eliminar este ingreso? Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              onPressed: () {
                dialogContext.pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: destructiveRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Eliminar'),
              onPressed: () {
                dialogContext.pop(); 
                onDelete(context, id); 
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountCard(BuildContext context, IncomeDetail income, Color primaryColor, IconData typeIcon,
      String amountText, String amountSign, String typeLabel) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(typeIcon, color: primaryColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              '$amountSign$amountText',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                typeLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, IncomeDetail income, Function(String) formatDate) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Información del Ingreso', 
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(height: 20, thickness: 1, color: theme.dividerColor),
            
            _DetailRow(
              icon: LucideIcons.fileText,
              label: 'Descripción',
              value: income.description,
            ),
            Divider(height: 20, thickness: 1, color: theme.dividerColor),
            
            _DetailRow(
              icon: LucideIcons.tag,
              label: 'Categoría',
              valueWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  income.category,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            Divider(height: 20, thickness: 1, color: theme.dividerColor),

            _KeyValueRow(
              keyLabel: 'Método de Recepción',
              value: income.paymentMethod,
            ),
            Divider(height: 20, thickness: 1, color: theme.dividerColor),
            
            _KeyValueRow(
              keyLabel: 'Fuente',
              value: income.source ?? 'N/A',
            ),
            Divider(height: 20, thickness: 1, color: theme.dividerColor),

            _DetailRow(
              icon: LucideIcons.calendar,
              label: 'Fecha y hora',
              value: formatDate(income.dateString),
              subtitle: income.time,
            ),
            
            if (income.notes != null && income.notes!.isNotEmpty) ...[
              Divider(height: 20, thickness: 1, color: theme.dividerColor),
              _DetailRow(
                icon: LucideIcons.clipboardList, 
                label: 'Notas',
                value: income.notes!,
                isNote: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String? subtitle;
  final Widget? valueWidget;
  final bool isNote;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.subtitle,
    this.valueWidget,
    this.isNote = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: isNote ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant), 
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              if (valueWidget != null)
                valueWidget!
              else if (value != null)
                Text(
                  value!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  softWrap: true,
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String keyLabel;
  final String value;
  final bool isMonospace;

  const _KeyValueRow({
    required this.keyLabel,
    required this.value,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyLabel,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: theme.colorScheme.onSurface,
                fontFamily: isMonospace ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}