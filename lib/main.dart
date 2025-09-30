import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:proyecto_final_01/app_router.dart'; 

const Color primaryBlue = Color(0xFF3182CE); 
const Color successGreen = Color(0xFF38A169); 
const Color dangerRed = Color(0xFFE53E3E); 
const Color lightBackground = Color(0xFFF7FAFC);
const Color cardColor = Colors.white;
const Color backgroundLight = Color(0xFFF7FAFC);
const Color mutedForeground = Color(0xFF6B7280); 
const Color cardBackground = Color(0xFFFFFFFF);
const Color foregroundColor = Color(0xFF1F2937); 
const Color destructiveRed = Color(0xFFE53E3E);

const Color darkBackground = Color(0xFF121212);
const Color darkCardColor = Color(0xFF1E1E1E);
const Color darkForegroundColor = Color(0xFFE0E0E0);
const Color darkMutedForeground = Color(0xFF9E9E9E);

// Modificamos el main para que sea async y preparemos la localización
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDateFormatting('es_ES', null);
  } catch (e) {
    debugPrint('Error al inicializar localización: $e');
  }
  runApp(const FlowUpApp());
}


class FlowUpApp extends StatelessWidget {
  const FlowUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlowUp: Tu dinero, tu control',
      debugShowCheckedModeBanner: false,
      
      routerConfig: router, 

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: lightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: cardBackground, 
          foregroundColor: foregroundColor, 
          centerTitle: true,
          elevation: 1,
        ),
        fontFamily: 'Inter',
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: darkBackground,
        cardColor: darkCardColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkCardColor, 
          foregroundColor: darkForegroundColor, 
          centerTitle: true,
          elevation: 1,
        ),
        fontFamily: 'Inter',
      ),

      themeMode: ThemeMode.system,
    );
  }
}