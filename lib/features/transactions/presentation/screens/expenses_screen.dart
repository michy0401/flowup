// lib/features/transactions/presentation/screens/expenses_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/widgets/app_drawer.dart';
import 'package:flowup/core/theme/app_colors.dart';
// Importamos los widgets que ya creamos
import 'package:flowup/features/home/presentation/widgets/summary_card.dart';
import 'package:flowup/features/home/presentation/widgets/transaction_list_tile.dart';
import 'package:go_router/go_router.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['Todos', 'Cat 1', 'Cat 2', 'Cat 3'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GASTOS', // <-- Título cambiado
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // --- 1. Sección Superior (Resumen y Botón) ---
          _buildTopSection(context),
          const SizedBox(height: 24),

          // --- 2. Barra de Búsqueda ---
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Buscar Gastos', // <-- Texto cambiado
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
          _buildExpenseList(), // <-- Lista cambiada
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
            title: 'GASTOS', // <-- Texto cambiado
            amount: '\$850.00',
            color: AppColors.redError, // <-- Color cambiado
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        // Botón "Nuevo Gasto"
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 38),
            ),
            onPressed: () {
              context.push('/expenses/new'); // <-- Ruta cambiada
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(height: 8),
                Text('Nuevo Gasto'), // <-- Texto cambiado
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
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // Helper para la lista de gastos
  Widget _buildExpenseList() {
    // Usamos los mismos datos de prueba del Home
    return Column(
      children: const [
        TransactionListTile(
          title: 'Compra en Supermercado',
          category: 'Comida',
          date: '08 Nov',
          amount: '120.00',
          isExpense: true, // <-- Importante
        ),
        TransactionListTile(
          title: 'Restaurante',
          category: 'Ocio',
          date: '07 Nov',
          amount: '45.00',
          isExpense: true, // <-- Importante
        ),
        TransactionListTile(
          title: 'Gasolina',
          category: 'Transporte',
          date: '06 Nov',
          amount: '50.00',
          isExpense: true, // <-- Importante
        ),
      ],
    );
  }
}