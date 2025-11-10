// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowup/core/theme/app_colors.dart'; // Para los colores de las tarjetas
import 'package:flowup/core/widgets/app_drawer.dart'; // Importa el Drawer global
import '../widgets/summary_card.dart'; // Importa el widget de la tarjeta
import '../widgets/transaction_list_tile.dart'; // Importa el widget de la lista

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      // 1. El AppBar con el título y el botón de menú
      appBar: AppBar(
        title: Text(
          'HOME',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        // El color del ícono del menú se hereda automáticamente
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      // 2. El Drawer (menú lateral)
      drawer: const AppDrawer(), // Usa el Drawer importado
      // 3. El body, en un ListView para que sea scrollable
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          // --- Cuadrícula de Resumen ---
          _buildSummaryGrid(context),

          const SizedBox(height: 24),

          // --- Lista de Transacciones ---
          Text(
            'TRANSACCIONES RECIENTES',
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          _buildRecentTransactions(),
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
                title: 'INGRESOS',
                amount: '\$1,500.00',
                color: AppColors.greenSuccess, // Color de nuestra paleta
                onTap: () => context.push('/income'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'GASTOS',
                amount: '\$850.00',
                color: AppColors.redError, // Color de nuestra paleta
                onTap: () => context.push('/expenses'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'AHORROS',
                amount: '\$500.00',
                onTap: () => context.push('/savings'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'INVERSIÓN',
                amount: '\$1,200.00',
                onTap: () => context.push('/investments'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper para la lista de transacciones (con datos de prueba)
  Widget _buildRecentTransactions() {
    return Column(
      children: const [
        TransactionListTile(
          title: 'Compra en Supermercado',
          category: 'Comida',
          date: '08 Nov', // (Los datos son de prueba)
          amount: '120.00',
          isExpense: true,
        ),
        TransactionListTile(
          title: 'Pago de Salario',
          category: 'Ingreso',
          date: '07 Nov',
          amount: '1,500.00',
        ),
        TransactionListTile(
          title: 'Restaurante',
          category: 'Ocio',
          date: '07 Nov',
          amount: '45.00',
          isExpense: true,
        ),
        TransactionListTile(
          title: 'Gasolina',
          category: 'Transporte',
          date: '06 Nov',
          amount: '50.00',
          isExpense: true,
        ),
      ],
    );
  }
}