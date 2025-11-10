// lib/features/transactions/presentation/screens/new_investment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class NewInvestmentScreen extends StatelessWidget {
  // Acepta una inversión opcional (para modo edición)
  final Map<String, dynamic>? investmentToEdit;

  const NewInvestmentScreen({
    super.key,
    this.investmentToEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final bool isEditing = investmentToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Título dinámico
          isEditing ? 'EDITAR INVERSION' : 'INVERSION',
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
            _NewInvestmentForm(investment: investmentToEdit),
          ],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario ---
class _NewInvestmentForm extends StatefulWidget {
  final Map<String, dynamic>? investment;

  const _NewInvestmentForm({this.investment});

  @override
  State<_NewInvestmentForm> createState() => __NewInvestmentFormState();
}

class __NewInvestmentFormState extends State<_NewInvestmentForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late final TextEditingController _dateController;
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _feesController;
  late final TextEditingController _conceptController;
  
  // Estado para los Dropdowns
  String? _selectedCategory;
  String? _selectedCurrency;
  final List<String> _categories = ['Acciones', 'Fondos', 'Crypto', 'Bonos', 'Otro'];
  final List<String> _currencies = ['USD', 'EUR', 'MXN', 'Local'];

  @override
  void initState() {
    super.initState();
    final data = widget.investment;

    _dateController = TextEditingController(text: data?['date']);
    _nameController = TextEditingController(text: data?['name']);
    _amountController = TextEditingController(text: data?['amount']);
    _feesController = TextEditingController(text: data?['fees']);
    _conceptController = TextEditingController(text: data?['concept']);
    _selectedCategory = data?['category'];
    _selectedCurrency = data?['currency'];
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _feesController.dispose();
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
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
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
    final bool isEditing = widget.investment != null;

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

          // --- CAMPO NOMBRE INVERSION ---
          Text('INVERSION', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Escribe el nombre de la inversión',
            ),
            keyboardType: TextInputType.text,
            validator: (value) => (value == null || value.isEmpty) ? 'Introduce un nombre' : null,
          ),
          const SizedBox(height: 24),

          // --- FILA DE MONTOS ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MONTO INVERTIDO', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      validator: (value) => (value == null || value.isEmpty) ? 'Introduce un monto' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COMISIONES', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _feesController,
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      validator: (value) => (value == null || value.isEmpty) ? 'Introduce comisiones' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // --- CAMPO DIVISA ---
          Text('DIVISA', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            decoration: const InputDecoration(
              hintText: 'Selecciona la divisa de la transacción',
            ),
            items: _currencies.map((String currency) {
              return DropdownMenuItem<String>(value: currency, child: Text(currency));
            }).toList(),
            onChanged: (newValue) => setState(() => _selectedCurrency = newValue),
            validator: (value) => (value == null) ? 'Selecciona una divisa' : null,
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