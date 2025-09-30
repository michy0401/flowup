import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// =========================================================================
// INTERFAZ DE DATOS DE LA TRANSACCIÓN (Estructura para Ingreso)
// =========================================================================

class TransactionData {
  double amount; // Monto (Siempre positivo para esta página)
  String category; // Categoría
  String receptionMethod; // Método de Recepción
  String source; // Fuente (Campo de texto, ej: nombre de la empresa)
  DateTime date; // Fecha
  String notes; // Notas
  String type; // 'income'

  TransactionData({
    required this.amount,
    required this.category,
    required this.receptionMethod, 
    required this.source,
    required this.date,
    required this.notes,
    this.type = 'income', // Fijo como 'income'
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(), // 1. Fecha
      'category': category, // 2. Categoría
      'receptionMethod': receptionMethod, // 3. Método de Recepción
      'source': source, // 4. Fuente
      'amount': amount, // 5. Monto (positivo)
      'notes': notes, // 6. Notas
      'type': type, 
      'createdAt': DateTime.now().toIso8601String(),
      // 'userId': 'TODO: Obtener User ID de Firebase Auth', 
    };
  }
}

// =========================================================================
// WIDGET PRINCIPAL DEL FORMULARIO DE INGRESO
// =========================================================================

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key}); 

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Color fijo para Ingreso
  final Color _incomeColor = Colors.green.shade600;

  // Estado del formulario
  DateTime _selectedDate = DateTime.now(); // 1. Fecha
  String? _category; // 2. Categoría
  String? _receptionMethod; // 3. Método de Recepción
  String _source = ''; // 4. Fuente (Nuevo campo de texto)
  String _amount = ''; // 5. Monto
  String _notes = ''; // 6. Notas

  // Definición de Categorías de Ingreso
  final List<String> _incomeCategories = [
    "Salario", "Freelance", "Inversiones", "Regalo", "Venta", "Otros ingresos"
  ];
  
  // Lista de Métodos de Recepción
  final List<String> _receptionMethods = [
    "Depósito Bancario", "Transferencia", "Efectivo", "Cheque", "Billetera Digital", "Otro"
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
      
      // Ingreso: Asegurar que el monto sea positivo
      final double finalAmount = amountValue.abs(); 

      final incomeTransaction = TransactionData(
        date: _selectedDate,
        category: _category!,
        receptionMethod: _receptionMethod!,
        source: _source,
        amount: finalAmount,
        notes: _notes,
        type: 'income',
      );

      print('Ingreso a guardar: ${incomeTransaction.toMap()}');
      
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Ingreso'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ORDEN SOLICITADO: Fecha, Categoría, Fuente, Método de Recepción, Monto, Notas

              // 1. Fecha
              _buildDateField(context),
              const SizedBox(height: 16.0),

              // 2. Categoría
              _buildCategoryDropdown(),
              const SizedBox(height: 16.0),

              // 3. Fuente
              _buildSourceField(),
              const SizedBox(height: 16.0),

              // 4. Método de Recepción
              _buildReceptionMethodDropdown(),
              const SizedBox(height: 16.0),

              // 5. Monto
              _buildAmountField(_incomeColor),
              const SizedBox(height: 16.0),
              
              // 6. Notas
              _buildNotesField(), 
              const SizedBox(height: 32.0),

              // Botones de Acción
              _buildActionButtons(_incomeColor),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                const SizedBox(width: 12.0),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
            /*
            Expanded( 
              child: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis, 
                maxLines: 1, 
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(Color primaryColor) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Monto',
        hintText: '0.00',
        prefixIcon: Icon(Icons.add_circle_outline, color: primaryColor), // Ícono de suma para ingreso
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: primaryColor),
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese un monto positivo válido.';
        }
        return null;
      },
      onSaved: (value) => _amount = value!,
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
      hint: const Text('Selecciona una categoría de ingreso'),
      items: _incomeCategories.map((String category) {
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

  Widget _buildReceptionMethodDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true, // Solución 1: Permite que el dropdown se expanda y trunque el texto.
      value: _receptionMethod, 
      decoration: InputDecoration(
        labelText: 'Método de Recepción',
        prefixIcon: const Icon(LucideIcons.wallet, color: Colors.grey), // Solución 3: Icono consistente.
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: const Text('Selecciona el método de recepción (ej: Transferencia)'),
      items: _receptionMethods.map((String method) {
        return DropdownMenuItem<String>(
          value: method,
          // Aseguramos que el texto dentro del item también se trunque si es muy largo.
          child: Text(method, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          // Solución 2: Corregir el bug que actualizaba la variable incorrecta.
          _receptionMethod = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El método de recepción es obligatorio.';
        }
        return null;
      },
      onSaved: (value) => _receptionMethod = value!,
    );
  }

  Widget _buildSourceField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Fuente',
        hintText: 'Ej: Nombre del cliente, empresa o banco',
        prefixIcon: const Icon(Icons.business, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La fuente del ingreso es obligatoria.';
        }
        return null;
      },
      onSaved: (value) => _source = value!,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Notas (Opcional)',
        hintText: 'Ej: Sueldo de enero, pago por proyecto X, etc.',
        prefixIcon: const Align(
          alignment: Alignment.topLeft,
          heightFactor: 2.0,
          child: Icon(Icons.notes, color: Colors.grey)
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSaved: (value) => _notes = value ?? '',
    );
  }
  
  Widget _buildActionButtons(Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Cancelar', 
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor, // Color verde para ingreso
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: const Text(
              'Guardar Ingreso',
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
