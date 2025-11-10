// lib/features/transactions/presentation/screens/new_saving_goal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha y los números

class NewSavingGoalScreen extends StatelessWidget {
  // Acepta una meta opcional (para modo edición)
  final Map<String, dynamic>? goalToEdit;

  const NewSavingGoalScreen({
    super.key,
    this.goalToEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final bool isEditing = goalToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Título dinámico
          isEditing ? 'EDITAR AHORRO' : 'AHORRO',
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
            _NewSavingGoalForm(goal: goalToEdit),
          ],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario ---
class _NewSavingGoalForm extends StatefulWidget {
  final Map<String, dynamic>? goal;

  const _NewSavingGoalForm({this.goal});

  @override
  State<_NewSavingGoalForm> createState() => __NewSavingGoalFormState();
}

class __NewSavingGoalFormState extends State<_NewSavingGoalForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _monthlyAmountController; // Este será calculado o editable
  late final TextEditingController _conceptController;
  
  // Estado para los Dropdowns
  String? _selectedCategory;
  final List<String> _categories = ['Viajes', 'Educación', 'Compras', 'Inversión', 'Otro'];

  // Variables para cálculos
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    final data = widget.goal;

    _startDateController = TextEditingController(text: data?['startDate']);
    _endDateController = TextEditingController(text: data?['endDate']);
    _targetAmountController = TextEditingController(text: data?['targetAmount']);
    _monthlyAmountController = TextEditingController(text: data?['monthlyContribution']);
    _conceptController = TextEditingController(text: data?['concept']);
    _selectedCategory = data?['category'];

    // Convertir strings de fecha a DateTime si existen para los cálculos
    if (data?['startDate'] != null && data?['startDate'].isNotEmpty) {
      _selectedStartDate = DateFormat('dd/MM/yyyy').parse(data!['startDate']);
    }
    if (data?['endDate'] != null && data?['endDate'].isNotEmpty) {
      _selectedEndDate = DateFormat('dd/MM/yyyy').parse(data!['endDate']);
    }

    // Añadir listeners para recalcular el monto mensual automáticamente
    _targetAmountController.addListener(_calculateMonthlyAmount);
    _startDateController.addListener(_calculateMonthlyAmount);
    _endDateController.addListener(_calculateMonthlyAmount);
  }

  @override
  void dispose() {
    _targetAmountController.removeListener(_calculateMonthlyAmount);
    _startDateController.removeListener(_calculateMonthlyAmount);
    _endDateController.removeListener(_calculateMonthlyAmount);

    _startDateController.dispose();
    _endDateController.dispose();
    _targetAmountController.dispose();
    _monthlyAmountController.dispose();
    _conceptController.dispose();
    super.dispose();
  }

  // --- Lógica para mostrar el Date Pickers ---
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller, Function(DateTime) onDateSelected) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
        onDateSelected(picked); // Actualiza la variable DateTime
      });
    }
  }

  // --- Lógica para calcular el monto mensual ---
  void _calculateMonthlyAmount() {
    // Solo recalcular si los campos principales no están vacíos
    if (_targetAmountController.text.isNotEmpty &&
        _selectedStartDate != null &&
        _selectedEndDate != null &&
        _selectedEndDate!.isAfter(_selectedStartDate!)) {
      
      final double targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
      
      final int months = _selectedEndDate!.difference(_selectedStartDate!).inDays ~/ 30; // Meses aproximados
      
      if (months > 0 && targetAmount > 0) {
        final double monthly = targetAmount / months;
        // Solo actualiza si no estamos en modo edición o si el campo está vacío
        // Esto permite al usuario editar manualmente si lo desea
        if (widget.goal == null || _monthlyAmountController.text.isEmpty) {
           _monthlyAmountController.text = monthly.toStringAsFixed(2);
        }
      } else {
        _monthlyAmountController.text = '0.00';
      }
    } else if (widget.goal == null) {
      // Si no hay datos y no se cumplen las condiciones, limpiar solo en modo nuevo
      _monthlyAmountController.text = '0.00';
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
    final bool isEditing = widget.goal != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CAMPOS DE FECHA ---
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FECHA INICIO', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '01/01/2001',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, _startDateController, (date) {
                        _selectedStartDate = date;
                        _calculateMonthlyAmount(); // Recalcula al cambiar la fecha
                      }),
                      validator: (value) => (value == null || value.isEmpty) ? 'Selecciona una fecha de inicio' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FECHA FIN', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '01/01/2001',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context, _endDateController, (date) {
                        _selectedEndDate = date;
                        _calculateMonthlyAmount(); // Recalcula al cambiar la fecha
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona una fecha fin';
                        }
                        if (_selectedStartDate != null && _selectedEndDate != null && _selectedEndDate!.isBefore(_selectedStartDate!)) {
                          return 'La fecha fin debe ser posterior a la fecha inicio';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
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

          // --- CAMPO META A AHORRAR ---
          Text('META A AHORRAR', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _targetAmountController,
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) => (value == null || value.isEmpty) ? 'Introduce la meta de ahorro' : null,
            onChanged: (value) => _calculateMonthlyAmount(), // Recalcula al cambiar el monto
          ),
          const SizedBox(height: 24),

          // --- CAMPO MONTO MENSUAL ---
          Text('MONTO MENSUAL', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _monthlyAmountController,
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) => (value == null || value.isEmpty) ? 'Introduce el monto mensual' : null,
            // Permite al usuario editar manualmente, pero se recalcula si los otros campos cambian.
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