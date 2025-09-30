import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

const Color primaryBlue = Color(0xFF3B82F6);
const Color foregroundColor = Color(0xFF1F2937);
const Color mutedForeground = Color(0xFF6B7280);

class GoalCategoryInfo {
  final String name;
  final IconData icon;
  final Color color;

  GoalCategoryInfo({required this.name, required this.icon, required this.color});
}

final List<GoalCategoryInfo> goalCategories = [
  GoalCategoryInfo(name: "Viaje", icon: LucideIcons.plane, color: Colors.blue.shade700),
  GoalCategoryInfo(name: "Educación", icon: LucideIcons.graduationCap, color: Colors.green.shade700),
  GoalCategoryInfo(name: "Transporte", icon: LucideIcons.car, color: Colors.orange.shade700),
  GoalCategoryInfo(name: "Vivienda", icon: LucideIcons.home, color: Colors.purple.shade700),
  GoalCategoryInfo(name: "Emergencia", icon: LucideIcons.shieldAlert, color: Colors.red.shade700),
  GoalCategoryInfo(name: "Tecnología", icon: LucideIcons.laptop, color: Colors.grey.shade800),
  GoalCategoryInfo(name: "Regalo", icon: LucideIcons.gift, color: Colors.pink.shade400),
  GoalCategoryInfo(name: "Otro", icon: LucideIcons.piggyBank, color: mutedForeground),
];

// =========================================================================
// WIDGET PRINCIPAL DEL FORMULARIO
// =========================================================================

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores y estado del formulario
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30)); // Default a 30 días
  GoalCategoryInfo? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Aquí iría la lógica para guardar la nueva meta en la base de datos o estado global.
      print('--- Nueva Meta Creada ---');
      print('Título: ${_titleController.text}');
      print('Descripción: ${_descriptionController.text}');
      print('Monto Objetivo: ${_targetAmountController.text}');
      print('Fecha Límite: ${_selectedDate.toIso8601String()}');
      print('Categoría: ${_selectedCategory!.name}');
      print('-------------------------');

      // Muestra un SnackBar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Nueva meta de ahorro creada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      // Cierra la pantalla del formulario
      Navigator.pop(context);
    }
  }

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nueva Meta', style: TextStyle(fontWeight: FontWeight.bold, color: foregroundColor)),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                controller: _titleController,
                label: 'Título de la Meta',
                hint: 'Ej: Vacaciones de verano',
                icon: LucideIcons.flag,
                validator: (value) => (value == null || value.isEmpty) ? 'El título es obligatorio.' : null,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _descriptionController,
                label: 'Descripción (Opcional)',
                hint: 'Ej: Viaje a la playa con la familia',
                icon: LucideIcons.text,
              ),
              // ORDEN CAMBIADO: Categoría ahora va antes que Monto
              const SizedBox(height: 16.0),
              _buildCategoryDropdown(),
              const SizedBox(height: 16.0),
              _buildAmountField(),
              const SizedBox(height: 16.0),
              _buildDateField(context),
              const SizedBox(height: 32.0),

              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CAMPO ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: mutedForeground, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _targetAmountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Monto Objetivo',
        hintText: '0.00',
        prefixIcon: const Icon(LucideIcons.dollarSign, color: mutedForeground, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese un monto objetivo válido.';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<GoalCategoryInfo>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Categoría',
        prefixIcon: Icon(_selectedCategory?.icon ?? LucideIcons.tag, color: _selectedCategory?.color ?? mutedForeground, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: const Text('Selecciona una categoría'),
      items: goalCategories.map((GoalCategoryInfo category) {
        return DropdownMenuItem<GoalCategoryInfo>(
          value: category,
          child: Row(
            children: [
              Icon(category.icon, color: category.color, size: 20),
              const SizedBox(width: 10),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (GoalCategoryInfo? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (value) => (value == null) ? 'La categoría es obligatoria.' : null,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha Límite',
          prefixIcon: const Icon(LucideIcons.calendar, color: mutedForeground, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES').format(_selectedDate),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
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
            child: const Text('Guardar Meta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}