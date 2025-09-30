import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proyecto_final_01/main.dart'; // Importar colores

const Color warningYellow = Color(0xFFD69E2E); // Un color para riesgo moderado

// --- CONFIGURACIÓN DE DATA Y TIPOS (MOCK) ---

// Modelo para una recomendación de inversión
class InvestmentRecommendation {
  final String title;
  final String description;
  final String riskLevel; // "Bajo", "Moderado", "Alto"
  final String expectedReturn;
  final IconData icon;
  final Color color;

  InvestmentRecommendation({
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.expectedReturn,
    required this.icon,
    required this.color,
  });
}

// Datos de simulación
final double availableToInvest = 1250.75;
final String userRiskProfile = "Moderado";

final List<InvestmentRecommendation> mockRecommendations = [
  InvestmentRecommendation(
    title: "Fondo Indexado S&P 500",
    description: "Invierte en las 500 empresas más grandes de EE.UU. con diversificación automática.",
    riskLevel: "Bajo",
    expectedReturn: "8-10% anual",
    icon: LucideIcons.barChart3,
    color: successGreen,
  ),
  InvestmentRecommendation(
    title: "Acciones de Tech Innovators",
    description: "Portafolio de acciones de empresas tecnológicas con alto potencial de crecimiento.",
    riskLevel: "Alto",
    expectedReturn: "15-25% anual",
    icon: LucideIcons.cpu,
    color: destructiveRed,
  ),
  InvestmentRecommendation(
    title: "Bonos Corporativos (Grado A)",
    description: "Préstamos a empresas estables con pagos de interés fijos y menor volatilidad.",
    riskLevel: "Bajo",
    expectedReturn: "4-6% anual",
    icon: LucideIcons.shield,
    color: primaryBlue,
  ),
  InvestmentRecommendation(
    title: "Fondo de Bienes Raíces (REIT)",
    description: "Invierte en un portafolio de propiedades comerciales y recibe dividendos.",
    riskLevel: "Moderado",
    expectedReturn: "7-9% anual",
    icon: LucideIcons.building,
    color: warningYellow,
  ),
];

// --- WIDGET PRINCIPAL DE LA PANTALLA DE INVERSIONES ---

class InvestmentScreen extends StatelessWidget {
  const InvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: statusBarHeight + 16.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Encabezado
                _buildHeader(context),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 2. Saldo disponible para invertir
                      _buildAvailableBalanceCard(),
                      const SizedBox(height: 16),

                      // 3. Botones de acción
                      _buildActionButtons(context),
                      const SizedBox(height: 24),

                      // 4. Perfil de riesgo
                      _buildRiskProfileCard(context),
                      const SizedBox(height: 24),

                      // 5. Recomendaciones de inversión
                      _buildRecommendationsSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _buildBottomNavBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inversiones',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: foregroundColor),
              ),
              Text(
                'Haz crecer tu dinero',
                style: TextStyle(fontSize: 12, color: mutedForeground),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('JD', style: TextStyle(color: cardBackground, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBalanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: primaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disponible para Invertir',
              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(availableToInvest),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/dashboard/add-investment'),
            icon: const Icon(LucideIcons.plus, size: 20),
            label: const Text('Nueva Inversión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: successGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/dashboard/portfolio'),
            icon: const Icon(LucideIcons.briefcase, size: 20),
            label: const Text('Mi Portafolio'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryBlue,
              side: const BorderSide(color: primaryBlue, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskProfileCard(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/dashboard/portfolio'),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(LucideIcons.gauge, color: primaryBlue, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu Perfil de Riesgo',
                      style: TextStyle(fontSize: 14, color: mutedForeground),
                    ),
                    Text(
                      userRiskProfile,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: foregroundColor),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: mutedForeground),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recomendaciones para ti',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: foregroundColor),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: mockRecommendations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = mockRecommendations[index];
            return InkWell(
              onTap: () => context.push('/dashboard/investment-detail/${item.title}'),
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item.icon, color: item.color, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: foregroundColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item.description, style: const TextStyle(fontSize: 14, color: mutedForeground)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildTag('Riesgo: ${item.riskLevel}', item.color),
                          const SizedBox(width: 8),
                          _buildTag(item.expectedReturn, successGreen),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, LucideIcons.home, 'Inicio', false, () => context.go('/dashboard')),
            _buildNavItem(context, LucideIcons.arrowUpRight, 'Ingreso', false, () => context.go('/dashboard/incomes')),
            _buildNavItem(context, LucideIcons.shoppingBag, 'Gasto', false, () => context.go('/dashboard/expenses')),
            _buildNavItem(context, LucideIcons.piggyBank, 'Ahorro', false, () => context.go('/dashboard/goals')),
            _buildNavItem(context, LucideIcons.trendingUp, 'Inversión', true, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isSelected, VoidCallback onTap) {
    final color = isSelected ? primaryBlue : mutedForeground;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}