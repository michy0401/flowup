import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:proyecto_final_01/main.dart'; 
enum GoalStatus { all, active, completed }

class Goal {
  final int id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final String deadline; // Usamos String para simplificar la conversión de Date
  final String category;
  final IconData icon;
  final Color color;
  final GoalStatus status;
  final double monthlyTarget;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.category,
    required this.icon,
    required this.color,
    required this.status,
    required this.monthlyTarget,
  });
}

final List<Goal> mockGoals = [
  Goal(
    id: 1,
    title: "Fondo de Emergencia",
    description: "6 meses de gastos básicos",
    targetAmount: 15000,
    currentAmount: 8500,
    deadline: "2024-12-31",
    category: "emergency",
    icon: Icons.favorite_border,
    color: Colors.red.shade700,
    status: GoalStatus.active,
    monthlyTarget: 650,
  ),
  Goal(
    id: 2,
    title: "Vacaciones en Europa",
    description: "Viaje de 2 semanas",
    targetAmount: 5000,
    currentAmount: 3200,
    deadline: "2024-07-15",
    category: "travel",
    icon: Icons.flight_outlined,
    color: Colors.blue.shade700,
    status: GoalStatus.active,
    monthlyTarget: 450,
  ),
  Goal(
    id: 3,
    title: "Auto Nuevo",
    description: "Enganche para vehículo",
    targetAmount: 8000,
    currentAmount: 2100,
    deadline: "2025-03-01",
    category: "transport",
    icon: Icons.directions_car_outlined,
    color: Colors.orange.shade700,
    status: GoalStatus.active,
    monthlyTarget: 590,
  ),
  Goal(
    id: 4,
    title: "Curso de Programación",
    description: "Bootcamp full-stack",
    targetAmount: 2500,
    currentAmount: 2500,
    deadline: "2024-01-15",
    category: "education",
    icon: Icons.school_outlined,
    color: Colors.green.shade700,
    status: GoalStatus.completed,
    monthlyTarget: 0,
  ),
  Goal(
    id: 5,
    title: "Enganche Casa",
    description: "20% del valor de la propiedad",
    targetAmount: 50000,
    currentAmount: 12000,
    deadline: "2025-12-31",
    category: "housing",
    icon: Icons.home_outlined,
    color: Colors.purple.shade700,
    status: GoalStatus.active,
    monthlyTarget: 1900,
  ),
];

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  GoalStatus _selectedFilter = GoalStatus.all;
  int _selectedIndex = 3; 

  void _onFilterTap(GoalStatus status) {
    setState(() {
      _selectedFilter = status;
    });
  }

  List<Goal> get _filteredGoals {
    return mockGoals.where((goal) {
      if (_selectedFilter == GoalStatus.all) return true;
      return goal.status == _selectedFilter;
    }).toList();
  }

  double get _totalGoalsAmount => mockGoals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  double get _totalSavedAmount => mockGoals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  int get _activeGoals => mockGoals.where((goal) => goal.status == GoalStatus.active).length;
  int get _completedGoals => mockGoals.where((goal) => goal.status == GoalStatus.completed).length;

  String _formatCurrency(double amount) => '\$${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: statusBarHeight + 16.0, bottom: 80.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: 16.0),

            _buildGoalsOverview(context),
            const SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildAddNewGoalButton(),
            ),
            const SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildFilterButtons(),
            ),
            const SizedBox(height: 16.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildGoalsList(),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Metas de Ahorro', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: foregroundColor),
                ),
                const Text(
                  'Gestión y seguimiento de objetivos',
                  style: TextStyle(fontSize: 12, color: mutedForeground),
                ),
              ],
            ),
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

  Widget _buildGoalsOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row( 
            children: [
              Expanded(child: _buildSummaryCard(
                title: 'Total Ahorrado',
                value: _formatCurrency(_totalSavedAmount),
                color: Colors.green.shade700,
                icon: Icons.attach_money,
                isCurrency: true,
                context: context,
              )),
              const SizedBox(width: 12.0),
              Expanded(child: _buildSummaryCard(
                title: 'Meta Total',
                value: _formatCurrency(_totalGoalsAmount),
                color: Colors.indigo,
                icon: Icons.stacked_bar_chart,
                isCurrency: true,
                context: context,
              )),
            ],
          ),
          const SizedBox(height: 12.0),
          Row( 
            children: [
              Expanded(child: _buildSummaryCard(
                title: 'Metas Activas',
                value: _activeGoals.toString(),
                color: primaryBlue,
                icon: Icons.flag_outlined,
                isCurrency: false,
                context: context,
              )),
              const SizedBox(width: 12.0),
              Expanded(child: _buildSummaryCard(
                title: 'Completadas',
                value: _completedGoals.toString(),
                color: Colors.pink,
                icon: Icons.check_circle_outline,
                isCurrency: false,
                context: context,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required bool isCurrency,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(icon, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              value,
              style: TextStyle(
                fontSize: isCurrency ? 22 : 26,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewGoalButton() {
    return ElevatedButton.icon(
      onPressed: () {
        context.push('/dashboard/add-goal');
      },
      icon: const Icon(Icons.add, size: 24),
      label: const Text(
        'Agregar Nueva Meta',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryBlue,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: <Widget>[
        _buildFilterChip(GoalStatus.all, 'Todas'),
        const SizedBox(width: 8),
        _buildFilterChip(GoalStatus.active, 'Activas'),
        const SizedBox(width: 8),
        _buildFilterChip(GoalStatus.completed, 'Completadas'),
      ],
    );
  }

  Widget _buildFilterChip(GoalStatus status, String label) {
    final bool isSelected = _selectedFilter == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onFilterTap(status);
        }
      },
      selectedColor: primaryBlue.withOpacity(0.9),
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade800,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: isSelected ? primaryBlue : Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      elevation: isSelected ? 2 : 0,
    );
  }

  Widget _buildGoalsList() {
    if (_filteredGoals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Text(
            'No hay metas en esta categoría.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredGoals.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GoalCard(goal: _filteredGoals[index], formatCurrency: _formatCurrency),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(LucideIcons.home, 'Inicio', false, () => context.go('/dashboard')),
            _buildNavItem(LucideIcons.arrowUpRight, 'Ingreso', false, () => context.go('/dashboard/incomes')),
            _buildNavItem(LucideIcons.shoppingBag, 'Gasto', false, () => context.go('/dashboard/expenses')),
            _buildNavItem(LucideIcons.piggyBank, 'Ahorro', true, () {}), 
            _buildNavItem(LucideIcons.trendingUp, 'Inversión', false, () => context.go('/dashboard/investments')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    final color = isSelected ? primaryBlue : mutedForeground;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  final Function(double) formatCurrency;
  const GoalCard({super.key, required this.goal, required this.formatCurrency});

  String _getTimeRemaining(String deadline) {
    final now = DateTime.now();
    final target = DateTime.parse(deadline);
    final diffDays = target.difference(now).inDays;

    if (diffDays < 0) return "Vencido";
    if (diffDays == 0) return "Hoy";
    if (diffDays == 1) return "Mañana";
    if (diffDays < 30) return "$diffDays días";
    if (diffDays < 365) return "${(diffDays / 30).ceil()} meses";
    return "${(diffDays / 365).ceil()} años";
  }

  Widget _getStatusBadge(GoalStatus status) {
    switch (status) {
      case GoalStatus.completed:
        return Chip(
          label: const Text('Completada', style: TextStyle(fontSize: 12)),
          backgroundColor: Colors.green.shade100,
          labelStyle: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      case GoalStatus.active:
        return Chip(
          label: const Text('En progreso', style: TextStyle(fontSize: 12)),
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = min(100.0, (goal.currentAmount / goal.targetAmount) * 100);
    final double remaining = goal.targetAmount - goal.currentAmount;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push('/dashboard/goal-detail/${goal.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: goal.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(goal.icon, color: goal.color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                goal.description,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _getStatusBadge(goal.status),
                                  const SizedBox(width: 8),
                                  Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    _getTimeRemaining(goal.deadline),
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue),
                      ),
                      Text(
                        'completado',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatCurrency(goal.currentAmount)} de ${formatCurrency(goal.targetAmount)}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      if (goal.status == GoalStatus.active)
                        Text(
                          '${formatCurrency(goal.monthlyTarget)}/mes',
                          style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        goal.status == GoalStatus.completed
                            ? "¡Meta alcanzada!"
                            : '${formatCurrency(remaining)} restante',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      Text(
                        goal.status == GoalStatus.active ? "En progreso" : "Completada",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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