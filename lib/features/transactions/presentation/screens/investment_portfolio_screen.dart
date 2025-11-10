// lib/features/transactions/presentation/screens/investment_portfolio_screen.dart
import 'package:flutter/material.dart';

class InvestmentPortfolioScreen extends StatelessWidget {
  const InvestmentPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio de Inversión'),
      ),
      body: const Center(
        child: Text('Pantalla de Portafolio (Placeholder)'),
      ),
    );
  }
}