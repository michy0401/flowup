import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:collection/collection.dart';

import 'package:proyecto_final_01/main.dart';
import 'package:proyecto_final_01/investment_screen.dart';

class InvestmentDetailScreen extends StatelessWidget {
  final String investmentTitle;

  const InvestmentDetailScreen({super.key, required this.investmentTitle});

  InvestmentRecommendation? _getInvestmentData() {
    return mockRecommendations.firstWhereOrNull((rec) => rec.title == investmentTitle);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final investment = _getInvestmentData();

    if (investment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('No se encontró la recomendación de inversión.', style: theme.textTheme.bodyLarge)),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, investment),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeaderCard(context, investment),
            const SizedBox(height: 16),
            _buildKeyDetailsCard(context, investment),
            const SizedBox(height: 16),
            _buildChartCard(context),
            const SizedBox(height: 24),
            _buildInvestButton(context, investment.title),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, InvestmentRecommendation investment) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 1,
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: theme.appBarTheme.foregroundColor),
        onPressed: () => context.pop(),
      ),
      title: Text(
        investment.title,
        style: theme.appBarTheme.titleTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderCard(BuildContext context, InvestmentRecommendation investment) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: investment.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(investment.icon, color: investment.color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              investment.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              investment.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyDetailsCard(BuildContext context, InvestmentRecommendation investment) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Detalles Clave',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(height: 24, thickness: 1, color: theme.dividerColor),
            _DetailRow(
              icon: LucideIcons.shield,
              label: 'Nivel de Riesgo',
              value: investment.riskLevel,
              valueColor: investment.color,
            ),
            Divider(height: 24, thickness: 1, color: theme.dividerColor),
            _DetailRow(
              icon: LucideIcons.trendingUp,
              label: 'Retorno Esperado (Anual)',
              value: investment.expectedReturn,
              valueColor: successGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rendimiento Histórico',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Gráfico de rendimiento (Placeholder)',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestButton(BuildContext context, String title) {
    return ElevatedButton.icon(
      onPressed: () {
        context.push('/dashboard/add-investment?title=$title');
      },
      icon: const Icon(LucideIcons.dollarSign, size: 20),
      label: const Text('Invertir Ahora'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}