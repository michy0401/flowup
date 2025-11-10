// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flowup/core/theme/app_colors.dart';
import 'package:flowup/core/widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list_tile.dart';
import '../providers/dashboard_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final dashboardSummaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: dashboardSummaryAsync.when(
        data: (summary) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardSummaryProvider);
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildSummaryGrid(
                  context,
                  income: summary.income,
                  expenses: summary.expenses,
                  balance: summary.balance,
                ),
                const SizedBox(height: 24),
                Text(
                  'TRANSACCIONES RECIENTES',
                  style: textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Próximamente verás tus transacciones recientes aquí',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error al cargar datos',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(dashboardSummaryProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context, {
    required String income,
    required String expenses,
    required String balance,
  }) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    // Parse amounts
    final incomeAmount = double.tryParse(income) ?? 0.0;
    final expensesAmount = double.tryParse(expenses) ?? 0.0;
    final balanceAmount = double.tryParse(balance) ?? 0.0;

    // Format amounts
    final formattedIncome = formatter.format(incomeAmount);
    final formattedExpenses = formatter.format(expensesAmount);
    final formattedBalance = formatter.format(balanceAmount);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'INGRESOS',
                amount: formattedIncome,
                color: AppColors.greenSuccess,
                onTap: () => context.push('/income'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'GASTOS',
                amount: formattedExpenses,
                color: AppColors.redError,
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
                title: 'BALANCE',
                amount: formattedBalance,
                color: balanceAmount >= 0 ? AppColors.greenSuccess : AppColors.redError,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'INVERSIÓN',
                amount: '\$0.00',
                onTap: () => context.push('/investments'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
