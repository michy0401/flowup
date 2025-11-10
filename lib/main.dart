// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

// Este Provider manejará el estado del tema (claro/oscuro)
// Por ahora, lo dejamos en 'system'
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // Puede ser .light, .dark, o .system
});

void main() {
  // Aquí irían inicializaciones (Firebase, etc.)
  runApp(
    // 1. Envolvemos la App en ProviderScope (¡Obligatorio para Riverpod!)
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Observamos el estado de nuestro provider de tema
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FlowUp',
      debugShowCheckedModeBanner: false,

      // --- Conexión de Temas ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // --- Conexión de GoRouter ---
      routerConfig: AppRouter.router,
    );
  }
}