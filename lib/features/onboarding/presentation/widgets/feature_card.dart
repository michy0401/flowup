// lib/features/onboarding/presentation/widgets/feature_card.dart
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: CircleAvatar(
            // <-- CORREGIDO: Usamos el color de la tarjeta
            backgroundColor: Theme.of(context).cardColor, 
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
              // <-- CORREGIDO: Tinta el icono con el color del texto
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          title: Text(
            title,
            style: textTheme.titleLarge,
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodyMedium, // El tema ya le da el color correcto
          ),
        ),
      ),
    );
  }
}