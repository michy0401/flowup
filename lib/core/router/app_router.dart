// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Importaciones de Pantallas ---
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/transactions/presentation/screens/income_screen.dart';
import '../../features/transactions/presentation/screens/new_income_screen.dart';
import '../../features/transactions/presentation/screens/income_detail_screen.dart';
import '../../features/transactions/presentation/screens/expenses_screen.dart';
import '../../features/transactions/presentation/screens/new_expense_screen.dart';
import '../../features/transactions/presentation/screens/expense_detail_screen.dart';
import '../../features/transactions/presentation/screens/savings_screen.dart';
import '../../features/transactions/presentation/screens/new_saving_goal_screen.dart';
import '../../features/transactions/presentation/screens/saving_goal_detail_screen.dart';
import '../../features/transactions/presentation/screens/investments_screen.dart';
import '../../features/transactions/presentation/screens/new_investment_screen.dart';
import '../../features/transactions/presentation/screens/investment_detail_screen.dart';
import '../../features/transactions/presentation/screens/investment_portfolio_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    
    // --- Definición de Rutas ---
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // --- Flujo de Ingresos ---
      GoRoute(
        path: '/income',
        name: 'income',
        builder: (context, state) => const IncomeScreen(),
        routes: [
          GoRoute(
            path: 'new', 
            name: 'new-income',
            builder: (context, state) {
              final transaction = state.extra as Map<String, dynamic>?;
              return NewIncomeScreen(transactionToEdit: transaction);
            },
          ),
          GoRoute(
            path: ':id', 
            name: 'income-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'error';
              return IncomeDetailScreen(transactionId: id);
            },
          ),
        ],
      ),
      
      // --- Flujo de Gastos ---
      GoRoute(
        path: '/expenses',
        name: 'expenses',
        builder: (context, state) => const ExpensesScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: 'new-expense',
            builder: (context, state) {
              final transaction = state.extra as Map<String, dynamic>?;
              return NewExpenseScreen(transactionToEdit: transaction);
            },
          ),
          GoRoute(
            path: ':id',
            name: 'expense-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'error';
              return ExpenseDetailScreen(transactionId: id);
            },
          ),
        ],
      ),

      // --- Flujo de Ahorros ---
      GoRoute(
        path: '/savings',
        name: 'savings',
        builder: (context, state) => const SavingsScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: 'new-saving-goal',
            builder: (context, state) {
              final goal = state.extra as Map<String, dynamic>?;
              return NewSavingGoalScreen(goalToEdit: goal);
            },
          ),
          GoRoute(
            path: ':id',
            name: 'saving-goal-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'error';
              return SavingGoalDetailScreen(goalId: id);
            },
          ),
        ],
      ),

      // --- Flujo de Inversiones ---
      GoRoute(
        path: '/investments',
        name: 'investments',
        builder: (context, state) => const InvestmentsScreen(),
        routes: [
          // --- ESTE ES EL BUILDER MODIFICADO ---
          GoRoute(
            path: 'new', // Se accederá como /investments/new
            name: 'new-investment',
            builder: (context, state) {
              // 1. Permite pasar datos para "Editar"
              final investment = state.extra as Map<String, dynamic>?;
              // 2. Los pasamos al constructor
              return NewInvestmentScreen(investmentToEdit: investment);
            },
          ),
          // ------------------------------------
          GoRoute(
            path: ':id', // Se accederá como /investments/123
            name: 'investment-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'error';
              return InvestmentDetailScreen(investmentId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/portfolio',
        name: 'portfolio',
        builder: (context, state) => const InvestmentPortfolioScreen(),
      ),

      // --- Otras rutas principales ---
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
    ],

    // --- Constructor de Error ---
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Ruta no encontrada: ${state.error}'),
      ),
    ),
  );
}