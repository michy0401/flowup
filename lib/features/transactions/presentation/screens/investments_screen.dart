// lib/features/transactions/presentation/screens/investments_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/widgets/app_drawer.dart';
// Importamos los widgets que necesitamos
import 'package:flowup/features/home/presentation/widgets/summary_card.dart';
import 'package:flowup/features/investments/presentation/widgets/investment_card.dart';
import 'package:go_router/go_router.dart';

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['Todos', 'Acciones', 'Fondos', 'Crypto'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INVERSIONES',
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
          // --- 1. Cuadrícula de Resumen y Botones ---
          _buildSummaryGrid(context),
          const SizedBox(height: 24),

          // --- 2. Barra de Búsqueda ---
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Buscar Inversión',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),

          // --- 3. Chips de Filtro ---
          _buildFilterChips(),
          const SizedBox(height: 24),

          // --- 4. Lista de Inversiones ---
          _buildInvestmentsList(),
        ],
      ),
    );
  }

  // Helper para la cuadrícula 2x2
  Widget _buildSummaryGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'TOTAL INVERTIDO',
                amount: '\$1,200.00',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'TOTAL INVERSIONES',
                amount: '2',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/portfolio'),
                child: const Text('Portafolio de Inversión'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/investments/new'),
                child: const Text('+ Nueva Inversión'),
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

  // Helper para la lista de inversiones (con datos de prueba)
  Widget _buildInvestmentsList() {
    return Column(
      children: const [
        InvestmentCard(
          investmentId: '1',
          title: 'Acciones de Tesla (TSLA)',
          description: 'Inversión en Acciones',
          status: 'Activo',
          timeframe: 'Largo Plazo',
          initialAmount: 1000.00,
          currentValue: 1200.00,
          percentageChange: 20.0,
          isNegative: false,
        ),
        SizedBox(height: 16),
        InvestmentCard(
          investmentId: '2',
          title: 'Fondo Mutuo S&P 500',
          description: 'Inversión en Fondo',
          status: 'Activo',
          timeframe: 'Largo Plazo',
          initialAmount: 500.00,
          currentValue: 450.00,
          percentageChange: -10.0,
          isNegative: true,
        ),
      ],
    );
  }
}