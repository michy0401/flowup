// lib/features/transactions/presentation/screens/new_expense_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NewExpenseScreen extends StatelessWidget {
  // Acepta una transacción opcional (para modo edición)
  final Map<String, dynamic>? transactionToEdit;

  const NewExpenseScreen({
    super.key,
    this.transactionToEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final bool isEditing = transactionToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Título dinámico
          isEditing ? 'EDITAR GASTO' : 'GASTO',
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
          children: [
            // Pasa los datos al formulario
            _NewExpenseForm(transaction: transactionToEdit),
          ],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario ---
class _NewExpenseForm extends StatefulWidget {
  final Map<String, dynamic>? transaction;

  const _NewExpenseForm({this.transaction});

  @override
  State<_NewExpenseForm> createState() => __NewExpenseFormState();
}

class __NewExpenseFormState extends State<_NewExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late final TextEditingController _dateController;
  late final TextEditingController _amountController;
  late final TextEditingController _conceptController;
  
  // Estado para los Dropdowns
  String? _selectedCategory;
  String? _selectedPaymentMethod;
  final List<String> _categories = ['Comida', 'Transporte', 'Ocio', 'Otro'];
  final List<String> _paymentMethods = ['Efectivo', 'Tarjeta de Crédito', 'Tarjeta de Débito'];

  @override
  void initState() {
    super.initState();
    // Rellena los controladores si estamos en modo edición
    final data = widget.transaction;
    _dateController = TextEditingController(text: data?['date']);
    _amountController = TextEditingController(text: data?['amount']);
    _conceptController = TextEditingController(text: data?['concept']);
    _selectedCategory = data?['category'];
    _selectedPaymentMethod = data?['paymentMethod'];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  // --- Lógica para mostrar el Date Picker ---
  Future<void> _selectDate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Formulario Válido');
      // Lógica de Riverpod iría aquí...
      context.pop(); // Regresar a la pantalla anterior
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
            readOnly: true,
            decoration: const InputDecoration(
              hintText: '01/01/2001',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _selectDate,
            validator: (value) => (value == null || value.isEmpty) ? 'Selecciona una fecha' : null,
          ),
          const SizedBox(height: 24),

          // --- CAMPO CATEGORIA ---
          Text('CATEGORIA', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              hintText: 'Selecciona una categoria',
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(value: category, child: Text(category));
            }).toList(),
            onChanged: (newValue) => setState(() => _selectedCategory = newValue),
            validator: (value) => (value == null) ? 'Selecciona una categoría' : null,
          ),
          const SizedBox(height: 24),

          // --- CAMPO METODO DE PAGO ---
          Text('METODO DE PAGO', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPaymentMethod,
            decoration: const InputDecoration(
              hintText: 'Selecciona una metodo',
            ),
            items: _paymentMethods.map((String method) {
              return DropdownMenuItem<String>(value: method, child: Text(method));
            }).toList(),
            onChanged: (newValue) => setState(() => _selectedPaymentMethod = newValue),
            validator: (value) => (value == null) ? 'Selecciona un método de pago' : null,
          ),
          const SizedBox(height: 24),

          // --- CAMPO MONTO ---
          Text('MONTO', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) => (value == null || value.isEmpty) ? 'Introduce un monto' : null,
          ),
          const SizedBox(height: 24),

          // --- CAMPO CONCEPTO ---
          Text('CONCEPTO', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _conceptController,
            decoration: const InputDecoration(
              hintText: 'Escribe el concepto de la transacción',
            ),
            keyboardType: TextInputType.text,
            maxLines: 3,
            validator: (value) => (value == null || value.isEmpty) ? 'Introduce un concepto' : null,
          ),
          const SizedBox(height: 32),

          // --- BOTÓN DE ENVIAR ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEditing ? 'Actualizar' : 'Enviar'), // Texto dinámico
            ),
          ),
        ],
      ),
    );
  }
}