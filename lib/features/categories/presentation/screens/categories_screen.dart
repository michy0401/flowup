// lib/features/categories/presentation/screens/categories_screen.dart
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: const Center(
        child: Text('Pantalla de Categorías (Placeholder)'),
      ),
    );
  }
}