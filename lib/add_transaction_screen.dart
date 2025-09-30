import 'package:flutter/material.dart';
// Importaciones de Firebase se manejan en el entorno Flutter real.
// Aquí simulamos el guardado y el User ID para la estructura del código.

// Interfaz (clase en Dart) para representar la data del Gasto
class ExpenseData {
  double amount; // Monto (se guardará como negativo)
  String category; // Categoría
  String paymentMethod; // Método de Pago
  DateTime date; // Fecha
  String notes; // Notas

  ExpenseData({
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(), // 1. Fecha
      'category': category, // 2. Categoría
      'paymentMethod': paymentMethod, // 3. Método de Pago
      'amount': amount, // 4. Monto (ya debería ser negativo)
      'notes': notes, // 5. Notas
      'type': 'expense', // Fijo como gasto
      'createdAt': DateTime.now().toIso8601String(),
      // 'userId': 'TODO: Obtener User ID de Firebase Auth', 
    };
  }
}

// =========================================================================
// WIDGET PRINCIPAL DEL FORMULARIO DE GASTO
// =========================================================================

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key}); 

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Estado del formulario, siguiendo el orden solicitado
  DateTime _selectedDate = DateTime.now(); // 1. Fecha
  String? _category; // 2. Categoría
  String? _paymentMethod; // 3. Método de Pago
  String _amount = ''; // 4. Monto
  String _notes = ''; // 5. Notas

  // Categorías de Gasto fijas
  final List<String> _expenseCategories = [
    "Alimentación", "Transporte", "Entretenimiento", "Servicios", "Salud", 
    "Educación", "Compras", "Otros gastos"
  ];

  final List<String> _paymentMethods = [
    "Efectivo", "Tarjeta de Débito", "Tarjeta de Crédito", "Transferencia Bancaria", 
    "Billetera Digital", "Otro"
  ];

  // =========================================================================
  // MÉTODOS DE LÓGICA
  // =========================================================================

  // Muestra el selector de fecha nativo de Flutter
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Lógica de guardado (simulada)
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final double amountValue = double.tryParse(_amount) ?? 0.0;
      // Ya que solo manejamos gastos, el monto final siempre es negativo (o cero).
      final double finalAmount = -amountValue.abs(); 

      final expense = ExpenseData(
        date: _selectedDate,
        category: _category!,
        paymentMethod: _paymentMethod!,
        amount: finalAmount,
        notes: _notes,
      );

      print('Gasto a guardar: ${expense.toMap()}');
      
      // TODO: Implementar guardado en Firestore aquí

      // Simular redirección (cerrar la página actual)
      Navigator.pop(context);
    }
  }

  // =========================================================================
  // BUILD UI
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    // Para simplificar, usamos un Scaffold con un AppBar estándar.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Gasto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Botón de regreso
        ),
        backgroundColor: Colors.white,
        elevation: 1, // Sombra sutil
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ORDEN SOLICITADO: Fecha, Categoría, Método de Pago, Monto, Notas

              // 1. Fecha
              _buildDateField(context),
              const SizedBox(height: 16.0),

              // 2. Categoría
              _buildCategoryDropdown(),
              const SizedBox(height: 16.0),

              // 3. Método de Pago
              _buildPaymentMethodDropdown(),
              const SizedBox(height: 16.0),
              
              // 4. Monto
              _buildAmountField(),
              const SizedBox(height: 16.0),

              // 5. Notas
              _buildNotesField(), 
              const SizedBox(height: 32.0),

              // Botones de Acción
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // WIDGETS DE CAMPO
  // =========================================================================

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha',
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: 'Categoría',
        prefixIcon: const Icon(Icons.category, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: const Text('Selecciona una categoría de gasto'),
      items: _expenseCategories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _category = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La categoría es obligatoria.';
        }
        return null;
      },
      onSaved: (value) => _category = value!,
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: _paymentMethod,
      decoration: InputDecoration(
        labelText: 'Método de Pago',
        prefixIcon: const Icon(Icons.credit_card, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: const Text('Selecciona el método de pago'),
      items: _paymentMethods.map((String method) {
        return DropdownMenuItem<String>(
          value: method,
          child: Text(method),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _paymentMethod = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El método de pago es obligatorio.';
        }
        return null;
      },
      onSaved: (value) => _paymentMethod = value!,
    );
  }
  
  Widget _buildAmountField() {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Monto',
        hintText: '0.00',
        prefixIcon: const Icon(Icons.remove_circle_outline, color: Colors.red), // Ícono de resta para gasto
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese un monto positivo válido (se registrará como gasto).';
        }
        return null;
      },
      onSaved: (value) => _amount = value!,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Notas (Opcional)',
        hintText: 'Ej: Pago de alquiler, cena con amigos, etc.',
        prefixIcon: const Align(
          alignment: Alignment.topLeft,
          heightFactor: 2.0, // Alineación para Textarea
          child: Icon(Icons.notes, color: Colors.grey)
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSaved: (value) => _notes = value ?? '',
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              // Color fijo de gasto (rojo)
              backgroundColor: Colors.red.shade600, 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: const Text(
              'Guardar Gasto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
