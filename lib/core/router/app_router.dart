// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Importaciones de Pantallas ---

// Onboarding (Basado en tu estructura de archivos)
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/register_screen.dart';

// Home
import '../../features/home/presentation/screens/home_screen.dart';

// Transacciones
import '../../features/transactions/presentation/screens/income_screen.dart';
import '../../features/transactions/presentation/screens/new_income_screen.dart';
import '../../features/transactions/presentation/screens/income_detail_screen.dart';
import '../../features/transactions/presentation/screens/expenses_screen.dart';
import '../../features/transactions/presentation/screens/new_expense_screen.dart';
import '../../features/transactions/presentation/screens/expense_detail_screen.dart';
import '../../features/transactions/presentation/screens/savings_screen.dart';
import '../../features/transactions/presentation/screens/investments_screen.dart';

// App Features
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
      
      // --- Rutas de la App (Dashboard) ---
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
          // --- ESTE ES EL BUILDER MODIFICADO ---
          GoRoute(
            path: 'new',
            name: 'new-expense',
            builder: (context, state) {
              // 1. Extraemos los datos para "Editar"
              final transaction = state.extra as Map<String, dynamic>?;
              // 2. Los pasamos al constructor
              return NewExpenseScreen(transactionToEdit: transaction);
            },
          ),
          // ------------------------------------
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

      // --- Otras rutas principales ---
      GoRoute(
        path: '/savings',
        name: 'savings',
        builder: (context, state) => const SavingsScreen(),
      ),
      GoRoute(
        path: '/investments',
        name: 'investments',
        builder: (context, state) => const InvestmentsScreen(),
      ),
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