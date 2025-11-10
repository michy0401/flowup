// lib/features/transactions/presentation/screens/investment_portfolio_screen.dart
import 'package:flutter/material.dart';
import 'package:flowup/core/theme/app_colors.dart'; // Para el color de contribuciones

class InvestmentPortfolioScreen extends StatelessWidget {
  const InvestmentPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PORTAFOLIO',
          style: textTheme.displaySmall?.copyWith(
            color: theme.primaryColor,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        children: [
          // --- 1. Tarjeta de Tipo de Portafolio ---
          _buildPortfolioTypeCard(context, textTheme),
          const SizedBox(height: 24),

          // --- 2. Tarjeta de Inversiones ---
          _buildInvestmentsCard(context, textTheme),
          const SizedBox(height: 24),

          // --- 3. Tarjeta de Contribuciones Recientes ---
          _buildContributionsCard(context, textTheme),
        ],
      ),
    );
  }

  // --- Helper: Tarjeta de Tipo de Portafolio ---
  Widget _buildPortfolioTypeCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TIPO DE PORTAFOLIO',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            Text(
              'Nivel de Riesgo',
              style: textTheme.bodySmall,
            ),
            Text(
              'Agresivo', // (Dato de prueba)
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Cantidad de inversiones',
              style: textTheme.bodySmall,
            ),
            Text(
              '2', // (Dato de prueba)
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Tarjeta de Inversiones ---
  Widget _buildInvestmentsCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INVERSIONES',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            // (Usamos datos de prueba)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Acciones de Tesla (TSLA)'),
              subtitle: const Text('Fecha de inicio: 01/01/2025'),
              trailing: Text(
                '\$1200.00',
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fondo Mutuo S&P 500'),
              subtitle: const Text('Fecha de inicio: 01/03/2025'),
              trailing: Text(
                '\$450.00',
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Tarjeta de Contribuciones ---
  Widget _buildContributionsCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CONTRIBUCIONES RECIENTES',
              style: textTheme.labelMedium,
            ),
            const Divider(height: 24),
            // (Datos de prueba)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aporte mensual'),
              subtitle: const Text('Fecha de el aporte: 01/11/2025'),
              trailing: Text(
                '+\$50.00',
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.greenSuccess,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Aporte mensual'),
              subtitle: const Text('Fecha de el aporte: 01/10/2025'),
              trailing: Text(
                '+\$50.00',
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.greenSuccess,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}