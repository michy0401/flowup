import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proyecto_final_01/main.dart'; // Importar colores

// Iconos utilizados en el diseño original:
const IconData iconGestiona = LucideIcons.trendingUp; // TrendingUp
const IconData iconAhorra = LucideIcons.shield; // Shield
const IconData iconInvierte = LucideIcons.arrowUp; // ArrowUp

// Este widget es la nueva pantalla de Bienvenida basada en tu prototipo Next.js
class WelcomeScreen extends StatefulWidget {
  // Ahora usaremos una función que acepta el BuildContext para la navegación
  final void Function(BuildContext context) onGetStarted;

  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  void _handleGetStarted() {
    setState(() {
      _isLoading = true;
    });
    // Simula la navegación después de una pequeña espera, como en el código React
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Usamos el contexto para la navegación
      widget.onGetStarted(context); 
      // Si navegamos, el estado de carga se reinicia al salir
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold actúa como el <div> principal con min-h-screen
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Logo y Eslogan (mb-8) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  children: [
                    // Icono central (w-20 h-20 bg-primary rounded-2xl shadow-lg)
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        iconInvierte, // Usamos el ícono ArrowUp del prototipo
                        size: 40,
                        color: cardBackground,
                      ),
                    ),
                    // Nombre (text-4xl font-bold)
                    const Text(
                      'FlowUp',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: foregroundColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Eslogan (text-lg text-muted-foreground)
                    const Text(
                      'Tu dinero, tu control',
                      style: TextStyle(
                        fontSize: 18,
                        color: mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Lista de Objetivos (space-y-4 mb-8) ---
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Column(
                  children: [
                    // Gestiona
                    _FeatureCard(
                      icon: iconGestiona,
                      iconColor: successGreen,
                      title: 'Gestiona',
                      subtitle: 'Controla tus ingresos y gastos',
                    ),
                    // Ahorra
                    _FeatureCard(
                      icon: iconAhorra,
                      iconColor: primaryBlue,
                      title: 'Ahorra',
                      subtitle: 'Metas inteligentes de ahorro',
                    ),
                    // Invierte
                    _FeatureCard(
                      icon: iconInvierte,
                      iconColor: dangerRed, // Rojo para diferenciarse del azul primario
                      title: 'Invierte',
                      subtitle: 'Multiplica tu dinero',
                    ),
                  ],
                ),
              ),

              // --- Botón CTA (w-full h-12 rounded-xl shadow-lg) ---
              ElevatedButton(
                onPressed: _isLoading ? null : _handleGetStarted,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: primaryBlue,
                  foregroundColor: cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: primaryBlue.withOpacity(0.4),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(cardBackground),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Iniciando...', style: TextStyle(fontSize: 18)),
                        ],
                      )
                    : const Text(
                        'Comenzar',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),

              // --- Términos y Condiciones (text-xs text-muted-foreground) ---
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Al continuar, aceptas nuestros términos y condiciones',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: mutedForeground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para las tarjetas de características (moved here)
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Card simula <Card className="p-4 bg-card/50 backdrop-blur-sm border-border/50">
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icono del feature (w-10 h-10 bg-color/10 rounded-lg)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            // Texto (text-left)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título (font-semibold)
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: foregroundColor),
                ),
                // Subtítulo (text-sm text-muted-foreground)
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 13, color: mutedForeground),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
