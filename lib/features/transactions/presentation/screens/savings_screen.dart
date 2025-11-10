// lib/features/transactions/presentation/screens/savings_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/widgets/app_drawer.dart';
// Importamos los widgets que necesitamos
import 'package:flowup/features/home/presentation/widgets/summary_card.dart';
import 'package:flowup/features/savings/presentation/widgets/saving_goal_card.dart';
import 'package:go_router/go_router.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['Todos', 'Activo', 'Pausado', 'Completado'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AHORROS',
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
          // --- 1. Cuadrícula de Resumen ---
          _buildSummaryGrid(context),
          const SizedBox(height: 24),

          // --- 2. Botón "Nueva Meta" ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/savings/new');
              },
              child: const Text('+ Nueva Meta Ahorro'),
            ),
          ),
          const SizedBox(height: 24),

          // --- 3. Barra de Búsqueda ---
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Buscar Ahorro',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),

          // --- 4. Chips de Filtro ---
          _buildFilterChips(),
          const SizedBox(height: 24),

          // --- 5. Lista de Metas ---
          _buildSavingsList(),
        ],
      ),
    );
  }

  // Helper para la cuadrícula 2x2
  Widget _buildSummaryGrid(BuildContext context) {
    // Reutilizamos el SummaryCard del Home
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'TOTAL AHORRADO',
                amount: '\$1,700.00',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'META TOTAL',
                amount: '\$5,000.00',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'METAS ACTIVAS',
                amount: '2',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'COMPLETADAS',
                amount: '1',
                onTap: () {},
              ),
            ),
          ],
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

  // Helper para la lista de metas (con datos de prueba)
  Widget _buildSavingsList() {
    return Column(
      children: const [
        SavingGoalCard(
          goalId: '123',
          title: 'Viaje a Japón',
          description: 'Ahorro para viaje en 2026',
          status: 'Activo',
          timeframe: 'Plazo: 24 meses',
          currentAmount: 1200.00,
          targetAmount: 5000.00,
          monthlyContribution: 160.00,
          isCompleted: false,
        ),
        SizedBox(height: 16),
        SavingGoalCard(
          goalId: '456',
          title: 'Nuevo Teléfono',
          description: 'Ahorro para el próximo iPhone',
          status: 'Activo',
          timeframe: 'Plazo: 6 meses',
          currentAmount: 500.00,
          targetAmount: 1200.00,
          monthlyContribution: 116.00,
          isCompleted: false,
        ),
        SizedBox(height: 16),
        SavingGoalCard(
          goalId: '789',
          title: 'Fondo de Emergencia',
          description: 'Ahorro inicial',
          status: 'Completado',
          timeframe: 'Plazo: 12 meses',
          currentAmount: 3000.00,
          targetAmount: 3000.00,
          monthlyContribution: 250.00,
          isCompleted: true,
        ),
      ],
    );
  }
}