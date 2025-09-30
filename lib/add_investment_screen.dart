import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

// --- Constantes de Colores ---
const Color primaryBlue = Color(0xFF3B82F6);
const Color foregroundColor = Color(0xFF1F2937);
const Color mutedForeground = Color(0xFF6B7280);
const Color successGreen = Color(0xFF38A169);

// =========================================================================
// WIDGET PRINCIPAL DEL FORMULARIO
// =========================================================================

class AddInvestmentScreen extends StatefulWidget {
  final String? investmentTitle; // Título opcional pre-cargado

  const AddInvestmentScreen({super.key, this.investmentTitle});

  @override
  State<AddInvestmentScreen> createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores y estado del formulario
  late TextEditingController _titleController;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador del título con el valor recibido (si existe)
    _titleController = TextEditingController(text: widget.investmentTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // --- MÉTODOS DE LÓGICA ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // No se puede invertir en el futuro
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

      // Aquí iría la lógica para guardar la nueva inversión en la base de datos
      print('--- Nueva Inversión Registrada ---');
      print('Título: ${_titleController.text}');
      print('Monto: ${_amountController.text}');
      print('Fecha: ${_selectedDate.toIso8601String()}');
      print('Notas: ${_notesController.text}');
      print('--------------------------------');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inversión registrada con éxito!'),
          backgroundColor: successGreen,
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
        title: const Text('Registrar Inversión', style: TextStyle(fontWeight: FontWeight.bold, color: foregroundColor)),
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
                label: 'Nombre de la Inversión',
                hint: 'Ej: Fondo Indexado S&P 500',
                icon: LucideIcons.barChart3,
                validator: (value) => (value == null || value.isEmpty) ? 'El nombre es obligatorio.' : null,
              ),
              const SizedBox(height: 16.0),
              _buildAmountField(),
              const SizedBox(height: 16.0),
              _buildDateField(context),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _notesController,
                label: 'Notas (Opcional)',
                hint: 'Ej: Aporte inicial al fondo...',
                icon: LucideIcons.clipboardList,
                maxLines: 3,
              ),
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
    int maxLines = 1,
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
      maxLines: maxLines,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Monto a Invertir',
        hintText: '0.00',
        prefixIcon: const Icon(LucideIcons.dollarSign, color: mutedForeground, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: successGreen),
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Ingrese un monto válido.';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha de Inversión',
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
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Guardar Inversión'),
          ),
        ),
      ],
    );
  }
}