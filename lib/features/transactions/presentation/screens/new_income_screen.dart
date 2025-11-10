// lib/features/transactions/presentation/screens/new_income_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NewIncomeScreen extends StatelessWidget {
  // 1. Acepta una transacción opcional
  final Map<String, dynamic>? transactionToEdit;

  const NewIncomeScreen({
    super.key,
    this.transactionToEdit, // Puede ser nulo (para "Nuevo")
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    // 2. Determina si estamos en modo edición
    final bool isEditing = transactionToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // 3. Título dinámico
          isEditing ? 'EDITAR INGRESO' : 'INGRESO',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          // 4. Pasa los datos al formulario
          children: [_NewIncomeForm(transaction: transactionToEdit)],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario ---
class _NewIncomeForm extends StatefulWidget {
  final Map<String, dynamic>? transaction;

  const _NewIncomeForm({this.transaction});

  @override
  State<_NewIncomeForm> createState() => __NewIncomeFormState();
}

class __NewIncomeFormState extends State<_NewIncomeForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _dateController;
  late final TextEditingController _originController;
  late final TextEditingController _amountController;
  late final TextEditingController _conceptController;
  
  String? _selectedCategory;
  final List<String> _categories = ['Salario', 'Venta', 'Regalo', 'Otro'];

  @override
  void initState() {
    super.initState();
    // 5. Rellena los controladores si estamos en modo edición
    final data = widget.transaction;
    _dateController = TextEditingController(text: data?['date']);
    _originController = TextEditingController(text: data?['origin']);
    _amountController = TextEditingController(text: data?['amount']);
    _conceptController = TextEditingController(text: data?['concept']);
    _selectedCategory = data?['category'];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _originController.dispose();
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    // ... (lógica de _selectDate sin cambios)
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Formulario Válido');
      // Lógica de Riverpod iría aquí...
      
      // Regresar a la pantalla anterior
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isEditing = widget.transaction != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CAMPO FECHA ---
          Text('FECHA', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dateController,
            // ... (resto del campo fecha sin cambios)
          ),
          const SizedBox(height: 24),

          // --- CAMPO CATEGORIA ---
          Text('CATEGORIA', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            hint: const Text('Selecciona una categoría'), // Se usa 'hint' en lugar de 'decoration'
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, selecciona una categoría';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // --- CAMPO ORIGEN ---
          Text('ORIGEN', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _originController,
            // ... (resto del campo origen sin cambios)
          ),
          const SizedBox(height: 24),

          // --- CAMPO MONTO ---
          Text('MONTO', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            // ... (resto del campo monto sin cambios)
          ),
          const SizedBox(height: 24),

          // --- CAMPO CONCEPTO ---
          Text('CONCEPTO', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _conceptController,
            // ... (resto del campo concepto sin cambios)
          ),
          const SizedBox(height: 32),

          // --- BOTÓN DE ENVIAR ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              // 6. Texto del botón dinámico
              child: Text(isEditing ? 'Actualizar' : 'Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}