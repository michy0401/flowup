import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:proyecto_final_01/main.dart'; 
import 'package:proyecto_final_01/investment_screen.dart';

class UserInvestment {
  final String title;
  final String category;
  final double amountInvested;
  final double currentValue;
  final IconData icon;
  final Color color;

  UserInvestment({
    required this.title,
    required this.category,
    required this.amountInvested,
    required this.currentValue,
    required this.icon,
    required this.color,
  });

  double get totalReturn => currentValue - amountInvested;
  double get returnPercentage => (totalReturn / amountInvested) * 100;
}

final List<UserInvestment> mockPortfolio = [
  UserInvestment(
    title: "Fondo Indexado S&P 500",
    category: "Renta Variable",
    amountInvested: 2500.00,
    currentValue: 2715.50,
    icon: LucideIcons.barChart3,
    color: successGreen,
  ),
  UserInvestment(
    title: "Bonos Corporativos (Grado A)",
    category: "Renta Fija",
    amountInvested: 1500.00,
    currentValue: 1545.20,
    icon: LucideIcons.shield,
    color: primaryBlue,
  ),
  UserInvestment(
    title: "Fondo de Bienes Raíces (REIT)",
    category: "Alternativos",
    amountInvested: 1000.00,
    currentValue: 985.00, // Ejemplo con pérdida
    icon: LucideIcons.building,
    color: warningYellow,
  ),
];

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  double get _totalInvested => mockPortfolio.fold(0.0, (sum, item) => sum + item.amountInvested);
  double get _currentTotalValue => mockPortfolio.fold(0.0, (sum, item) => sum + item.currentValue);
  double get _totalGainLoss => _currentTotalValue - _totalInvested;
  double get _totalReturnPercentage => (_totalGainLoss / _totalInvested) * 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRiskProfileCard(context),
            const SizedBox(height: 24),

            _buildPortfolioSummary(context),
            const SizedBox(height: 24),

            _buildInvestmentsList(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 1,
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: theme.appBarTheme.foregroundColor),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Mi Portafolio',
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildRiskProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(LucideIcons.gauge, color: primaryBlue, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Tu Perfil de Riesgo', 
              style: TextStyle(fontSize: 16, color: mutedForeground),
            ),
            const SizedBox(height: 4),
            Text(
              userRiskProfile, 
              style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Buscas un equilibrio entre crecimiento y preservación del capital, aceptando una volatilidad moderada para obtener rendimientos superiores a la inflación.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSummary(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '\$');
    final isPositiveReturn = _totalGainLoss >= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del Portafolio', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Valor Total Actual', style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurfaceVariant)),
                Text(formatter.format(_currentTotalValue), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ganancia/Pérdida Total', style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurfaceVariant)),
                Text(
                  '${isPositiveReturn ? '+' : ''}${formatter.format(_totalGainLoss)} (${_totalReturnPercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPositiveReturn ? successGreen : destructiveRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentsList(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis Inversiones',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mockPortfolio.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = mockPortfolio[index];
            return _buildInvestmentItem(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildInvestmentItem(BuildContext context, UserInvestment item) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '\$');
    final isPositive = item.totalReturn >= 0;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.push('/dashboard/user-investment-detail/${item.title}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(item.icon, color: item.color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(item.category, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatter.format(item.currentValue), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        '${isPositive ? '+' : ''}${item.returnPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? successGreen : destructiveRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}