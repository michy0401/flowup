import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Importamos constantes y datos de la pantalla de inversiones
import 'package:proyecto_final_01/main.dart'; // Importar colores globales
import 'package:proyecto_final_01/investment_screen.dart';

// --- MODELOS Y DATOS MOCK PARA EL PORTAFOLIO ---

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

  // Propiedades calculadas
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

// --- WIDGET PRINCIPAL DE LA PANTALLA ---

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  // --- Cálculos del Portafolio ---
  double get _totalInvested => mockPortfolio.fold(0.0, (sum, item) => sum + item.amountInvested);
  double get _currentTotalValue => mockPortfolio.fold(0.0, (sum, item) => sum + item.currentValue);
  double get _totalGainLoss => _currentTotalValue - _totalInvested;
  double get _totalReturnPercentage => (_totalGainLoss / _totalInvested) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Tarjeta de Perfil de Riesgo
            _buildRiskProfileCard(),
            const SizedBox(height: 24),

            // 2. Resumen del Portafolio
            _buildPortfolioSummary(),
            const SizedBox(height: 24),

            // 3. Lista de Inversiones
            _buildInvestmentsList(context),
          ],
        ),
      ),
    );
  }

  // Componente: AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: cardBackground,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: foregroundColor),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        'Mi Portafolio',
        style: TextStyle(fontWeight: FontWeight.bold, color: foregroundColor, fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  // Componente: Tarjeta de Perfil de Riesgo
  Widget _buildRiskProfileCard() {
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
              userRiskProfile, // Dato de investment_screen.dart
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: foregroundColor),
            ),
            const SizedBox(height: 12),
            const Text(
              'Buscas un equilibrio entre crecimiento y preservación del capital, aceptando una volatilidad moderada para obtener rendimientos superiores a la inflación.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  // Componente: Resumen del Portafolio
  Widget _buildPortfolioSummary() {
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
            const Text('Resumen del Portafolio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Valor Total Actual', style: TextStyle(fontSize: 15, color: mutedForeground)),
                Text(formatter.format(_currentTotalValue), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ganancia/Pérdida Total', style: TextStyle(fontSize: 15, color: mutedForeground)),
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

  // Componente: Lista de Inversiones
  Widget _buildInvestmentsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mis Inversiones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: foregroundColor),
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

  // Componente: Item individual de la lista de inversiones
  Widget _buildInvestmentItem(BuildContext context, UserInvestment item) {
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
                        Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(item.category, style: const TextStyle(fontSize: 13, color: mutedForeground)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatter.format(item.currentValue), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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