import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart'; 
import 'package:lucide_icons/lucide_icons.dart';

import 'package:proyecto_final_01/main.dart';
import 'package:proyecto_final_01/expenses_screen.dart';

class TransactionDetail {
  final String id;
  final String category;
  final String description;
  final double amount; // Valor absoluto (usaremos el signo basado en 'type')
  final String dateString;
  final String time;
  final String? notes;
  final String? location;
  final String paymentMethod;

  TransactionDetail({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.dateString,
    required this.time,
    required this.notes,
    required this.location,
    required this.paymentMethod,
  });
}

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  TransactionDetail? _getMockTransaction() {
    final expense = mockExpenses.firstWhereOrNull((exp) => exp.id == transactionId);

    if (expense == null) return null;

    return TransactionDetail(
      id: expense.id,
      category: expense.category,
      description: expense.description,
      amount: expense.amount,
      dateString: DateFormat('yyyy-MM-dd').format(expense.date),
      time: DateFormat('HH:mm').format(expense.date),
      notes: expense.notes, 
      location: expense.location, 
      paymentMethod: "Tarjeta de débito",
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
    print("Eliminando transacción: $id");
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final transaction = _getMockTransaction(); 

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No se encontró la transacción.')),
      );
    }
    
    final Color primaryColor = Colors.red.shade700;
    final IconData typeIcon = getCategoryIconData(transaction.category);
    const String typeLabel = 'Gasto';
    const String amountSign = '-';
    final String amountText = NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(transaction.amount);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, transaction, primaryColor, _handleDelete),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildAmountCard(context, transaction, primaryColor, typeIcon, amountText, amountSign, typeLabel),
            const SizedBox(height: 16),

            _buildDetailsCard(transaction, _formatDate),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, TransactionDetail transaction, Color color, Function(BuildContext, String) onDelete) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
        onPressed: () => context.pop(), 
      ),
      title: const Text(
        'Detalle',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: Icon(LucideIcons.edit, color: color, size: 20),
          onPressed: () {
            print('Navegar a Editar Transacción ${transaction.id}');
          },
        ),
        IconButton(
          icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
          onPressed: () => _showDeleteConfirmation(context, transaction.id, onDelete),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id, Function(BuildContext, String) onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: const [
              const Icon(LucideIcons.alertTriangle, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text('Eliminar transacción', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que quieres eliminar esta transacción? Esta acción no se puede deshacer.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                dialogContext.pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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

  Widget _buildAmountCard(BuildContext context, TransactionDetail transaction, Color primaryColor, IconData typeIcon,
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

  Widget _buildDetailsCard(TransactionDetail transaction, Function(String) formatDate) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Información',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.black12),
            
            _DetailRow(
              icon: LucideIcons.fileText,
              label: 'Descripción',
              value: transaction.description,
            ),
            const Divider(height: 20, thickness: 1, color: Colors.black12),
            
            _DetailRow(
              icon: LucideIcons.tag,
              label: 'Categoría',
              valueWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  transaction.category,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.black12),

            _KeyValueRow(
              keyLabel: 'Método de pago',
              value: transaction.paymentMethod,
            ),
            const Divider(height: 20, thickness: 1, color: Colors.black12),
            
            _DetailRow(
              icon: LucideIcons.calendar,
              label: 'Fecha y hora',
              value: formatDate(transaction.dateString),
              subtitle: transaction.time,
            ),
            
            if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
              const Divider(height: 20, thickness: 1, color: Colors.black12),
              _DetailRow(
                icon: LucideIcons.fileText,
                label: 'Notas',
                value: transaction.notes!,
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
    return Row(
      crossAxisAlignment: isNote ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              if (valueWidget != null)
                valueWidget!
              else if (value != null)
                Text(
                  value!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  softWrap: true,
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          keyLabel,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: isMonospace ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}
