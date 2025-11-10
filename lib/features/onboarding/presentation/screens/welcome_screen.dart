// lib/features/onboarding/presentation/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Asegúrate que la ruta a tu widget sea correcta
import '../widgets/feature_card.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Usamos esto para el espaciado, pero ahora no romperá el layout
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        // 1. CAMBIAMOS EL WIDGET 'Column' POR 'ListView'
        //    (Y quitamos el 'Padding' exterior, lo pondremos en el ListView)
        child: ListView(
          // 2. Añadimos el padding aquí
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          
          // 3. 'children' ahora es la lista de widgets de la pantalla
          children: [
            
            // 4. Reemplazamos el 'Spacer()' por un 'SizedBox'
            SizedBox(height: screenHeight * 0.05), // Espacio superior

            Image.asset(
              'assets/images/logo.png',
              height: screenHeight * 0.15, // Esto está bien
            ),
            const SizedBox(height: 16),
            Text(
              'Flow Up',
              textAlign: TextAlign.center,
              style: textTheme.displaySmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),

            // --- Sección Media: Features (Esto queda igual) ---
            const FeatureCard(
              iconPath: 'assets/images/icon_gestion.png',
              title: 'Gestiona',
              subtitle: 'Controla tus ingresos y gastos',
            ),
            const SizedBox(height: 16),
            const FeatureCard(
              iconPath: 'assets/images/icon_ahorro.png',
              title: 'Ahorra',
              subtitle: 'Metas inteligentes de ahorro',
            ),
            const SizedBox(height: 16),
            const FeatureCard(
              iconPath: 'assets/images/icon_inversion.png',
              title: 'Invierte',
              subtitle: 'Multiplica tu dinero',
            ),

            // 5. Reemplazamos el 'Spacer(flex: 2)' por un 'SizedBox'
            SizedBox(height: screenHeight * 0.10), // Espacio antes del botón

            // 6. ListView no estira a sus hijos, así que
            //    envolvemos el botón para que ocupe el ancho.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Esto ya debería funcionar por tus correcciones anteriores
                   context.push('/login');
                },
                child: const Text('Start'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Al continuar, acepta nuestros\ntérminos y condiciones',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 24), // Espacio inferior
          ],
        ),
      ),
    );
  }
}