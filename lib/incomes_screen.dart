import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proyecto_final_01/main.dart'; 

class Income {
  final String id;
  final String category;
  final String description;
  final double amount; 
  final DateTime date;
  final String userId;
  final String? notes; 
  final String? source; // Reemplazamos 'location' por 'source' (fuente)

  Income({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.userId,
    this.notes,
    this.source,
  });
}

class IncomeCategory {
  final String value;
  final String label;
  final IconData icon;
  final Color color = successGreen; 

  IncomeCategory({required this.value, required this.label, required this.icon});
}

final List<IncomeCategory> incomeCategories = [
  IncomeCategory(value: "all", label: "Todos", icon: LucideIcons.monitor),
  IncomeCategory(value: "Salario", label: "Salario", icon: LucideIcons.briefcase),
  IncomeCategory(value: "Freelance", label: "Freelance", icon: LucideIcons.code),
  IncomeCategory(value: "Inversiones", label: "Inversiones", icon: LucideIcons.trendingUp),
  IncomeCategory(value: "Regalo", label: "Regalo", icon: LucideIcons.gift),
  IncomeCategory(value: "Venta", label: "Venta", icon: LucideIcons.tag),
  IncomeCategory(value: "Otros", label: "Otros", icon: LucideIcons.wallet),
];

final List<Income> mockIncomes = [
  Income(
    id: 'i1',
    category: 'Salario',
    description: 'Pago mensual de ABC Corp',
    amount: 2500.00,
    date: DateTime(2024, 10, 30, 09, 00),
    userId: 'user-flutter-id-12345',
    notes: "Sueldo de Octubre. Depósito directo a cuenta de ahorro.",
    source: "Banco Mercantil",
  ),
  Income(
    id: 'i2',
    category: 'Freelance',
    description: 'Proyecto web para Cliente X',
    amount: 450.00,
    date: DateTime(2024, 10, 28, 16, 15),
    userId: 'user-flutter-id-12345',
    source: "Plataforma PayPal",
  ),
  Income(
    id: 'i3',
    category: 'Venta',
    description: 'Venta de equipo usado (Laptop)',
    amount: 300.00,
    date: DateTime(2024, 10, 25, 12, 00),
    userId: 'user-flutter-id-12345',
    notes: "Venta rápida por MarketPlace.",
  ),
  Income(
    id: 'i4',
    category: 'Inversiones',
    description: 'Dividendos de acciones BZ',
    amount: 15.50,
    date: DateTime(2024, 10, 24, 11, 30),
    userId: 'user-flutter-id-12345',
    source: "Broker Global Trade",
  ),
  Income(
    id: 'i5',
    category: 'Regalo',
    description: 'Regalo de cumpleaños de mi madre',
    amount: 50.00,
    date: DateTime(2024, 10, 20, 19, 00),
    userId: 'user-flutter-id-12345',
    notes: "Para el fondo de vacaciones.",
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

IconData getIncomeCategoryIconData(String category) {
  final cat = incomeCategories.firstWhere(
    (c) => c.value == category,
    orElse: () => incomeCategories.last,
  );
  return cat.icon;
}

class IncomesScreen extends StatefulWidget {
  final String userId = 'user-flutter-id-12345';

  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  String searchQuery = "";
  String selectedFilter = "all"; 
  List<Income> incomes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchIncomes();
  }

  Future<void> _fetchIncomes() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 500)); 
    
    incomes = mockIncomes
      ..sort((a, b) => b.date.compareTo(a.date));

    setState(() => isLoading = false);
  }

  double get totalIncomes {
    return incomes.fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Income> get filteredIncomes {
    List<Income> filtered = incomes.where((t) {
      final matchesCategory = selectedFilter == "all" ? true : t.category == selectedFilter;

      final matchesSearch = t.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.category.toLowerCase().contains(searchQuery.toLowerCase());
      
      return matchesCategory && matchesSearch;
    }).toList();

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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

              // 5. Lista de Transacciones (Ingresos)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildIncomeListCard(),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Ingresos', 
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Gestión de Ingresos',
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
    final theme = Theme.of(context);
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Buscar ingresos por descripción o categoría...',
        prefixIcon: Icon(LucideIcons.search, color: theme.colorScheme.onSurfaceVariant, size: 20),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.surface.withOpacity(0.1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: successGreen, width: 2.0), 
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
            title: 'Ingresos del mes', 
            amount: totalIncomes,
            icon: LucideIcons.arrowUpCircle, 
            iconColor: successGreen, 
            amountColor: successGreen, 
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionCard(
            title: 'Agregar Ingreso', 
            subtitle: 'Registra un nuevo ingreso', 
            icon: LucideIcons.plus,
            actionColor: primaryBlue, 
            onTap: () {
              context.push('/dashboard/add-income');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: incomeCategories.length,
        itemBuilder: (context, index) {
          final cat = incomeCategories[index];
          final isSelected = selectedFilter == cat.value;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat.label, style: TextStyle(fontWeight: FontWeight.w500)),
              selected: isSelected,
              selectedColor: successGreen.withOpacity(0.2), 
              backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              labelStyle: TextStyle(
                color: isSelected ? successGreen : theme.colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? successGreen : Colors.transparent),
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

  Widget _buildIncomeListCard() {
    final incomesList = filteredIncomes;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Resumen de Ingresos (${incomesList.length})', 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(color: successGreen), 
              ),
            )
          else if (incomesList.isEmpty)
            const _EmptyState()
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: incomesList.length,
              separatorBuilder: (context, index) => Divider(height: 1, indent: 16, endIndent: 16, color: theme.scaffoldBackgroundColor),
              itemBuilder: (context, index) {
                return _IncomeListItem(income: incomesList[index]);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70, 
        decoration: BoxDecoration(
          color: theme.cardColor,
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
            _buildNavItem(LucideIcons.arrowUpRight, 'Ingreso', true, () {}), 
            _buildNavItem(LucideIcons.shoppingBag, 'Gasto', false, () => context.go('/dashboard/expenses')),
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
    final theme = Theme.of(context);
    final color = isSelected ? successGreen : theme.colorScheme.onSurfaceVariant; 
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
    final theme = Theme.of(context);
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
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant),
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
              style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
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

class _IncomeListItem extends StatelessWidget {
  final Income income;

  const _IncomeListItem({required this.income});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        context.push('/dashboard/income-detail/${income.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible( 
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: successGreen.withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        getIncomeCategoryIconData(income.category),
                        size: 24,
                        color: successGreen, 
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          income.description,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis, 
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: successGreen.withOpacity(0.15), 
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                income.category,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: successGreen), 
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(LucideIcons.calendar, size: 12, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              '${formatDate(income.date)} • ${DateFormat('HH:mm').format(income.date)}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0), 
              child: Text(
                '+${NumberFormat.currency(locale: 'es_ES', symbol: '\$').format(income.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16, 
                  color: successGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Icon(LucideIcons.wallet, size: 48, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            '¡Parece que no hay ingresos registrados aún!', 
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 16),
          ),
          Text(
            'Presiona "Agregar Ingreso" para empezar a registrar tus ganancias.', 
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}