// lib/core/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart'; // Importamos main.dart para acceder al provider

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    // Observamos el estado actual del tema
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. Cabecera del Drawer (como en el mockup)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            child: Text(
              'MENU',
              style: textTheme.displaySmall?.copyWith(
                color: theme.primaryColor,
                fontSize: 32,
              ),
            ),
          ),

          // --- 2. ENLACE A HOME (AÑADIDO) ---
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => context.go('/home'),
          ),
          // ---------------------------------

          // 3. Enlaces de Navegación
          ListTile(
            leading: const Icon(Icons.arrow_upward),
            title: const Text('Ingresos'),
            onTap: () => context.go('/income'),
          ),
          ListTile(
            leading: const Icon(Icons.arrow_downward),
            title: const Text('Gastos'),
            onTap: () => context.go('/expenses'),
          ),
          ListTile(
            leading: const Icon(Icons.savings_outlined),
            title: const Text('Ahorros'),
            onTap: () => context.go('/savings'),
          ),
          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Inversiones'),
            onTap: () => context.go('/investments'),
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Categorias'),
            onTap: () => context.go('/categories'),
          ),

          const Divider(height: 32),

          // 4. Sección de Perfil
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Perfil'),
            onTap: () => context.go('/profile'),
          ),

          // 5. Toggle de Tema
          SwitchListTile(
            title: Text(isDarkMode ? 'Modo Oscuro' : 'Modo Claro'),
            secondary: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            value: isDarkMode,
            onChanged: (newValue) {
              // Actualizamos el estado de nuestro provider
              ref.read(themeModeProvider.notifier).state =
                  newValue ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
    );
  }
}