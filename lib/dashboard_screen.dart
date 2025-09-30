import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

const Color primaryBlue = Color(0xFF3182CE); 
const Color backgroundLight = Color(0xFFF7FAFC);

const Color mutedForeground = Color(0xFF6B7280); 
const Color cardBackground = Color(0xFFFFFFFF);
const Color foregroundColor = Color(0xFF1F2937); 
const Color successGreen = Color(0xFF38A169); 
const Color destructiveRed = Color(0xFFE53E3E); 

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final Map<String, dynamic> financialData = const {
    'totalBalance': 45250.75,
    'monthlyIncome': 8500.0,
    'monthlyExpenses': 6200.0,
    'savings': 15000.0, // Monto total ahorrado
    'balanceChange': 12.5, // Cambio respecto al mes anterior
    'incomeChange': 8.2,
    'expensesChange': -3.1,
    'savingsChange': 15.0,
  };

  final List<Map<String, dynamic>> transactionData = const [
    {'name': 'Supermercado Central', 'category': 'Alimentación', 'date': 'Hoy', 'amount': -85.5, 'icon': LucideIcons.shoppingCart},
    {'name': 'Pago mensual', 'category': 'Salario', 'date': 'Ayer', 'amount': 2800.0, 'icon': LucideIcons.arrowUpRight},
    {'name': 'Gasolina', 'category': 'Transporte', 'date': '2 días', 'amount': -45.0, 'icon': LucideIcons.car},
    {'name': 'Internet', 'category': 'Servicios', 'date': '3 días', 'amount': -65.0, 'icon': LucideIcons.wifi},
    {'name': 'Café con amigos', 'category': 'Entretenimiento', 'date': '4 días', 'amount': -12.5, 'icon': LucideIcons.coffee},
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: backgroundLight,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: statusBarHeight + 10, bottom: 80), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, statusBarHeight),
                
                const SizedBox(height: 16),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceOverview(financialData),
                      const SizedBox(height: 16),
                      
                      _buildQuickStats(financialData),
                      const SizedBox(height: 16),

                      _buildCard(
                        title: 'Resumen Financiero',
                        subtitle: 'Ingresos vs Gastos - Últimos 6 meses',
                        content: const SizedBox(height: 250, child: Center(child: Text("Gráfico Financiero (Placeholder)"))),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildQuickActions(context),
                      const SizedBox(height: 16),

                      _buildRecentTransactions(transactionData),
                      const SizedBox(height: 40), 
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomNavBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double statusBarHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(12), 
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('JD', style: TextStyle(color: cardBackground, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '¡Hola, Juan!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: foregroundColor),
                  ),
                  Text(
                    'Bienvenido de vuelta',
                    style: TextStyle(fontSize: 14, color: mutedForeground),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell, color: foregroundColor),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceOverview(Map<String, dynamic> data) {
    return Card(
      color: primaryBlue,
      elevation: 6, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance Total',
                      style: TextStyle(color: cardBackground, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${data['totalBalance'].toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        color: cardBackground,
                        fontSize: 40, 
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardBackground.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.trendingUp, size: 18, color: cardBackground),
                      const SizedBox(width: 6),
                      Text(
                        '+${data['balanceChange']}%',
                        style: const TextStyle(color: cardBackground, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Ingresos',
                amount: data['monthlyIncome'],
                change: data['incomeChange'],
                icon: LucideIcons.arrowUpRight,
                color: successGreen,
                isPositive: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Gastos',
                amount: data['monthlyExpenses'],
                change: data['expensesChange'],
                icon: LucideIcons.shoppingBag,
                color: destructiveRed,
                isPositive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Ahorros',
                amount: data['savings'],
                change: data['savingsChange'],
                icon: LucideIcons.piggyBank,
                color: primaryBlue, 
                isPositive: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Inversiones',
                amount: 5000.0, 
                change: 5.5, 
                icon: LucideIcons.trendingUp,
                color: successGreen,
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required double amount,
    required double change,
    required IconData icon,
    required Color color,
    required bool isPositive,
  }) {
    final String changeSign = isPositive ? '+' : '';
    final IconData trendIcon = isPositive ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: mutedForeground, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${amount.toStringAsFixed(0).replaceAll('.', ',')}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: foregroundColor),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  trendIcon,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  '$changeSign${change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return _buildCard(
      title: 'Acciones Rápidas',
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem(
              'Ingreso', LucideIcons.arrowUpRight, successGreen.withOpacity(0.1), successGreen, 
              onTap: () => context.go('/dashboard/incomes'),
            ),
            _buildQuickActionItem(
              'Gasto', LucideIcons.shoppingBag, destructiveRed.withOpacity(0.1), destructiveRed, 
              onTap: () => context.go('/dashboard/expenses'),
            ),
            _buildQuickActionItem(
              'Ahorrar', LucideIcons.piggyBank, primaryBlue.withOpacity(0.1), primaryBlue, 
              onTap: () => context.go('/dashboard/goals'),
            ),
            _buildQuickActionItem(
              'Invertir', LucideIcons.trendingUp, mutedForeground.withOpacity(0.1), mutedForeground, 
              onTap: () => context.go('/dashboard/investments'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(String label, IconData icon, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap ?? () => print('Acción rápida: $label'),
          borderRadius: BorderRadius.circular(18), 
          child: Container(
            width: 68, 
            height: 68,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: foregroundColor, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildRecentTransactions(List<Map<String, dynamic>> transactions) {
    return _buildCard(
      title: 'Transacciones Recientes',
      action: TextButton(
        onPressed: () {
          print('Ver todas las transacciones');
        },
        child: const Text('Ver todas', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
      ),
      content: Column(
        children: transactions.map((tx) => _buildTransactionItem(tx)).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    final bool isIncome = tx['amount'] > 0;
    final Color amountColor = isIncome ? successGreen : destructiveRed;
    final String sign = isIncome ? '+' : '';
    final String formattedAmount = '\$${sign}${tx['amount'].abs().toStringAsFixed(2).replaceAll('.', ',')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tx['icon'] as IconData, color: primaryBlue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: foregroundColor, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      tx['category'] as String,
                      style: const TextStyle(fontSize: 13, color: mutedForeground),
                    ),
                    const Text(' • ', style: TextStyle(fontSize: 13, color: mutedForeground)),
                    Text(
                      tx['date'] as String,
                      style: const TextStyle(fontSize: 13, color: mutedForeground),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(
            formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: amountColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, String? subtitle, Widget? action, required Widget content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: foregroundColor),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 14, color: mutedForeground),
                      ),
                    ],
                  ],
                ),
                if (action != null) action,
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
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
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, -5), 
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(LucideIcons.home, 'Inicio', true, () => context.go('/dashboard')), 
            _buildNavItem(
              LucideIcons.arrowUpRight, 'Ingreso', false,
              () => context.go('/dashboard/incomes'),
            ),
            _buildNavItem(
              LucideIcons.shoppingBag, 'Gasto', false, 
              () => context.go('/dashboard/expenses'),
            ),
            _buildNavItem(
              LucideIcons.piggyBank, 'Ahorro', false,
              () => context.go('/dashboard/goals'),
            ),
            _buildNavItem(
              LucideIcons.trendingUp, 'Inversión', false,
              () => context.go('/dashboard/investments'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    final color = isSelected ? primaryBlue : mutedForeground;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
