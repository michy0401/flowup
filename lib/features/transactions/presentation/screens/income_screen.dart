// lib/features/transactions/presentation/screens/income_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/widgets/app_drawer.dart';
import 'package:flowup/core/theme/app_colors.dart';
// Importamos los widgets que ya creamos para el Home
import 'package:flowup/features/home/presentation/widgets/summary_card.dart';
import 'package:flowup/features/home/presentation/widgets/transaction_list_tile.dart';
import 'package:go_router/go_router.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // Variable para guardar el estado del chip seleccionado
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['Todos', 'Cat 1', 'Cat 2', 'Cat 3'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INGRESO',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(), // Usamos el mismo menú lateral
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // --- 1. Sección Superior (Resumen y Botón) ---
          _buildTopSection(context),
          const SizedBox(height: 24),

          // --- 2. Barra de Búsqueda ---
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Buscar Ingresos',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),

          // --- 3. Chips de Filtro ---
          _buildFilterChips(),
          const SizedBox(height: 24),

          // --- 4. Lista de Transacciones ---
          Text(
            'TRANSACCIONES RECIENTES',
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          _buildIncomeList(),
        ],
      ),
    );
  }

  // Helper para la sección superior
  Widget _buildTopSection(BuildContext context) {
    return Row(
      children: [
        // Tarjeta de Resumen
        Expanded(
          child: SummaryCard(
            title: 'INGRESOS',
            amount: '\$1,500.00',
            color: AppColors.greenSuccess,
            onTap: () {}, // Ya estamos en Ingresos
          ),
        ),
        const SizedBox(width: 16),
        // Botón "Nuevo Ingreso"
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // Hacemos que tenga la misma altura que la tarjeta
              padding: const EdgeInsets.symmetric(vertical: 38), 
            ),
            onPressed: () {
              // Navegamos a la sub-ruta
              context.push('/income/new');
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(height: 8),
                Text('Nuevo Ingreso'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper para los chips
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_chipLabels.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(_chipLabels[index]),
              selected: _selectedChipIndex == index,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedChipIndex = index;
                    // Aquí iría la lógica para filtrar la lista
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // Helper para la lista de ingresos
  Widget _buildIncomeList() {
    // Usamos los mismos datos de prueba, pero solo los ingresos
    return Column(
      children: const [
        TransactionListTile(
          title: 'Pago de Salario',
          category: 'Ingreso',
          date: '07 Nov',
          amount: '1,500.00',
          isExpense: false, // Importante
        ),
        TransactionListTile(
          title: 'Venta online',
          category: 'Ingreso',
          date: '05 Nov',
          amount: '250.00',
          isExpense: false,
        ),
        // ... (añadir más si se desea)
      ],
    );
  }
}