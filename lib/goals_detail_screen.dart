import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proyecto_final_01/main.dart'; 

class Expense {
  final String id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String userId;
  final String? notes; 
  final String? location; 

  Expense({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.userId,
    this.notes,
    this.location,
  });
}

class ExpenseCategory {
  final String value;
  final String label;
  final IconData icon;
  final Color color = Colors.red.shade600; 

  ExpenseCategory({required this.value, required this.label, required this.icon});
}

final List<ExpenseCategory> expenseCategories = [
  ExpenseCategory(value: "all", label: "Todos", icon: LucideIcons.monitor),
  ExpenseCategory(value: "Alimentación", label: "Alimentación", icon: LucideIcons.shoppingCart),
  ExpenseCategory(value: "Transporte", label: "Transporte", icon: LucideIcons.car),
  ExpenseCategory(value: "Vivienda", label: "Vivienda", icon: LucideIcons.home),
  ExpenseCategory(value: "Servicios", label: "Servicios", icon: LucideIcons.droplet),
  ExpenseCategory(value: "Entretenimiento", label: "Entretenimiento", icon: LucideIcons.coffee),
  ExpenseCategory(value: "Otros", label: "Otros", icon: LucideIcons.wallet),
];

final List<Expense> mockExpenses = [
  Expense(
    id: 'e1',
    category: 'Alimentación',
    description: 'Supermercado Central',
    amount: 85.50,
    date: DateTime(2024, 10, 27, 14, 30),
    userId: 'user-flutter-id-12345',
    notes: "Compras semanales: frutas, verduras, lácteos y productos de limpieza.",
    location: "Av. Principal 123, Ciudad",
  ),
  Expense(
    id: 'e2',
    category: 'Transporte',
    description: 'Gasolina Shell',
    amount: 45.00,
    date: DateTime(2024, 10, 26, 18, 45),
    userId: 'user-flutter-id-12345',
    location: "Estación Shell, Calle Secundaria",
  ),
  Expense(
    id: 'e3',
    category: 'Vivienda',
    description: 'Electricidad',
    amount: 65.00,
    date: DateTime(2024, 10, 25, 10, 15),
    userId: 'user-flutter-id-12345',
    notes: "Pago correspondiente al mes de Octubre.",
  ),
  Expense(
    id: 'e4',
    category: 'Entretenimiento',
    description: 'Cine y palomitas',
    amount: 25.00,
    date: DateTime(2024, 10, 24, 15, 30),
    userId: 'user-flutter-id-12345',
    location: "Cinepolis Plaza Mayor",
  ),
  Expense(
    id: 'e5',
    category: 'Alimentación',
    description: 'Almuerzo oficina',
    amount: 12.50,
    date: DateTime(2024, 10, 27, 12, 00),
    userId: 'user-flutter-id-12345',
    notes: "Comida en el restaurante cercano al trabajo.",
  ),
];

String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(Duration(days: 1));

  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) {
    return "Hoy";
  } else if (dateOnly == yesterday) {
    return "Ayer";
  } else {
    return DateFormat('dd MMM', 'es_ES').format(date);
  }
}

IconData getCategoryIconData(String category) {
  final cat = expenseCategories.firstWhere(
    (c) => c.value == category,
    orElse: () => expenseCategories.last,
  );
  return cat.icon;
}

class ExpensesScreen extends StatefulWidget {
  final String userId = 'user-flutter-id-12345';

  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String searchQuery = "";
  String selectedFilter = "all"; 
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 500)); 
    
    expenses = mockExpenses
      ..sort((a, b) => b.date.compareTo(a.date));

    setState(() => isLoading = false);
  }

  double get totalExpenses {
    return expenses.fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Expense> get filteredExpenses {
    List<Expense> filtered = expenses.where((t) {
      final matchesCategory = selectedFilter == "all" ? true : t.category == selectedFilter;

      final matchesSearch = t.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(searchQuery.toLowerCase());
      
      return matchesCategory && matchesSearch;
    }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
  // Obtenemos la altura de la barra de estado para evitar que el contenido se superponga.
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
              _buildHeader(context),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: _buildSearchBar(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSummaryCards(context),
              ),
              
              const SizedBox(height: 24),

              _buildCategoryChips(),
              
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildExpenseListCard(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
          _buildBottomNavBar(context),
      ],
    )
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gastos', 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: foregroundColor),
              ),
              Text(
                'Gestión de Egresos',
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Buscar gastos por descripción o categoría...',
        prefixIcon: Icon(LucideIcons.search, color: mutedForeground, size: 20),
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardBackground.withOpacity(0.1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: destructiveRed, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Gastos del mes',
            amount: totalExpenses,
            icon: LucideIcons.arrowDownCircle,
            iconColor: destructiveRed,
            amountColor: destructiveRed,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionCard(
            title: 'Agregar Gasto',
            subtitle: 'Registra un nuevo egreso',
            icon: LucideIcons.plus,
            actionColor: primaryBlue,
            onTap: () {
              context.push('/dashboard/add-transaction');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: expenseCategories.length,
        itemBuilder: (context, index) {
          final cat = expenseCategories[index];
          final isSelected = selectedFilter == cat.value;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat.label, style: TextStyle(fontWeight: FontWeight.w500)),
              selected: isSelected,
              selectedColor: destructiveRed.withOpacity(0.15),
              backgroundColor: mutedForeground.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? destructiveRed : foregroundColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? destructiveRed : Colors.transparent),
              ),
              elevation: 0,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    selectedFilter = cat.value;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseListCard() {
    final expensesList = filteredExpenses;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Resumen de Transacciones (${expensesList.length})',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: foregroundColor),
            ),
          ),
          
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(color: destructiveRed),
              ),
            )
          else if (expensesList.isEmpty)
            const _EmptyState()
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: expensesList.length,
              separatorBuilder: (context, index) => Divider(height: 1, indent: 16, endIndent: 16, color: backgroundLight),
              itemBuilder: (context, index) {
                return _ExpenseListItem(expense: expensesList[index]);
              },
            ),
        ],
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
            _buildNavItem(LucideIcons.home, 'Inicio', false, () => context.go('/dashboard')),
            _buildNavItem(
              LucideIcons.arrowUpRight, 'Ingreso', false, 
              () => context.go('/dashboard/incomes'),
            ),
            _buildNavItem(LucideIcons.shoppingBag, 'Gasto', true, () {}), 
            _buildNavItem(
              LucideIcons.piggyBank, 'Ahorro', false, 
              () => context.go('/dashboard/goals'),
            ),
            _buildNavItem(LucideIcons.trendingUp, 'Inversión', false, () => context.go('/dashboard/investments')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    final color = isSelected ? destructiveRed : mutedForeground;

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

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color iconColor;
  final Color amountColor;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title, 
                  style: TextStyle(fontSize: 14, color: mutedForeground),
                ),
                Icon(icon, size: 24, color: iconColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(amount),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: amountColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Desde el inicio del periodo', 
              style: TextStyle(fontSize: 10, color: mutedForeground.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color actionColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.actionColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: actionColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Item en la lista de gastos
class _ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const _ExpenseListItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navegar a la pantalla de detalle, pasando el ID del gasto como argumento.
        context.push('/dashboard/transaction-detail/${expense.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icono de la Categoría
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: destructiveRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      getCategoryIconData(expense.category),
                      size: 24,
                      color: destructiveRed,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descripción
                    Text(
                      expense.description,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: foregroundColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Categoría
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: destructiveRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            expense.category,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: destructiveRed),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Fecha y Hora
                        Icon(LucideIcons.calendar, size: 12, color: mutedForeground),
                        const SizedBox(width: 4),
                        Text(
                          '${formatDate(expense.date)} • ${DateFormat('HH:mm').format(expense.date)}',
                          style: TextStyle(fontSize: 12, color: mutedForeground),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Monto (siempre negativo, siempre rojo)
            Text(
              '-${NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(expense.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16, 
                color: destructiveRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Estado Vacío
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Icon(LucideIcons.ghost, size: 48, color: mutedForeground.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            '¡Todo tranquilo! No hay gastos registrados.',
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedForeground, fontSize: 16),
          ),
          Text(
            'Presiona "Agregar Gasto" para empezar a registrar tus egresos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedForeground.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}