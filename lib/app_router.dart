import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:proyecto_final_01/auth_screen.dart';
import 'package:proyecto_final_01/dashboard_screen.dart';
import 'package:proyecto_final_01/expenses_screen.dart' as expenses;
import 'package:proyecto_final_01/incomes_screen.dart';
import 'package:proyecto_final_01/add_transaction_screen.dart';
import 'package:proyecto_final_01/add_income_screen.dart';
import 'package:proyecto_final_01/goals_screen.dart';
import 'package:proyecto_final_01/goals_detail_screen.dart' as goalsDetail;
import 'package:proyecto_final_01/add_goal_screen.dart';
import 'package:proyecto_final_01/investment_screen.dart';
import 'package:proyecto_final_01/investment_detail_screen.dart';
import 'package:proyecto_final_01/add_investment_screen.dart';
import 'package:proyecto_final_01/portfolio_screen.dart' as portfolioScreen;
import 'package:proyecto_final_01/user_investment_detail_screen.dart';
import 'package:proyecto_final_01/welcome_screen.dart';
import 'package:proyecto_final_01/transaction_detail_screen.dart' as transactionDetail;
import 'package:proyecto_final_01/income_detail_screen.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false; 

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

final AuthNotifier authNotifier = AuthNotifier();

final GoRouter router = GoRouter(
  initialLocation: '/',

  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = authNotifier.isLoggedIn;
    
    final bool isLoggingIn = state.matchedLocation == '/auth';
    final bool isHome = state.matchedLocation == '/';

    if (!loggedIn && !isLoggingIn && !isHome) {
      return '/auth';
    }

    if (loggedIn && (isLoggingIn || isHome)) {
      return '/dashboard';
    }

    return null;
  },
  
  refreshListenable: authNotifier,
  
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => WelcomeScreen( 
        onGetStarted: (ctx) => context.go('/auth'), 
      ),
    ),

    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthScreen(
        onLoginSuccess: () {
          authNotifier.login(); 
          context.go('/dashboard');
        }
      ),
    ),
    
    // RUTA DASHBOARD Y RUTAS ANIDADAS (Protegidas por el redirect)
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'expenses',
          builder: (context, state) => const expenses.ExpensesScreen(),
        ),
        GoRoute(
          path: 'transaction-detail/:id',
          builder: (context, state) {
            final String transactionId = state.pathParameters['id']!;
            return TransactionDetailScreen(transactionId: transactionId);
          },
        ),
        
        GoRoute(
          path: 'incomes',
          builder: (context, state) => const IncomesScreen(),
        ),
        GoRoute(
          path: 'income-detail/:id',
          builder: (context, state) {
            final String incomeId = state.pathParameters['id']!;
            return IncomeDetailScreen(incomeId: incomeId);
          },
        ),

        GoRoute(
          path: 'add-transaction',
          builder: (context, state) => const AddTransactionPage(),
        ),
        GoRoute(
          path: 'add-income',
          builder: (context, state) => const AddIncomePage(),
        ),
        
        GoRoute(
          path: 'goals',
          builder: (context, state) => const GoalsPage(),
        ),
        GoRoute(
          path: 'add-goal',
          builder: (context, state) => const AddGoalScreen(),
        ),
        GoRoute(
          path: 'goal-detail/:id',
          builder: (context, state) {
            final int goalId = int.parse(state.pathParameters['id']!);
            return Container(child: Text('Pantalla de detalle de meta no implementada'));
          },
        ),

        GoRoute(
          path: 'investments',
          builder: (context, state) => const InvestmentScreen(),
        ),
        GoRoute(
          path: 'investment-detail/:title',
          builder: (context, state) {
            final String title = state.pathParameters['title']!;
            return InvestmentDetailScreen(investmentTitle: title);
          },
        ),
        GoRoute(
          path: 'portfolio',
          builder: (context, state) => const portfolioScreen.PortfolioScreen(),
        ),
        GoRoute(
          path: 'add-investment',
          builder: (context, state) {
            final String? title = state.uri.queryParameters['title'];
            return AddInvestmentScreen(investmentTitle: title);
          },
        ),
        GoRoute(
          path: 'user-investment-detail/:title',
          builder: (context, state) {
            final String title = state.pathParameters['title']!;
            return Container(child: Text('Pantalla de detalle de inversión de usuario no implementada'));
          },
        ),
      ],
    ),
  ],
);