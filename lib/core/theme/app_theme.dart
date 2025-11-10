// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      // ... (tu configuración de colorScheme)
    ),
    textTheme: _textTheme(baseColor: AppColors.lightOnBg),
    cardTheme: CardThemeData(
      // ... (tu configuración de cardTheme)
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      // ... (tu configuración de elevatedButtonTheme)
    ),

    // --- AÑADE ESTE BLOQUE ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withOpacity(0.05), // Gris claro
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Sin borde
      ),
      labelStyle: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
    ),
    // -------------------------
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      // ... (tu configuración de colorScheme)
    ),
    textTheme: _textTheme(baseColor: AppColors.darkOnBg),
    cardTheme: CardThemeData(
      // ... (tu configuración de cardTheme)
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      // ... (tu configuración de elevatedButtonTheme)
    ),

    // --- AÑADE ESTE BLOQUE ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1), // Gris oscuro sutil
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Sin borde
      ),
      labelStyle: const TextStyle(color: AppColors.lightBackground, fontWeight: FontWeight.bold),
    ),
    // -------------------------
  );

  // ... (El resto de tu archivo _elevatedButtonTheme y _textTheme)
  // --- BUTTONS THEME ---
  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // --- TEXT THEME (CORREGIDO) ---
  static TextTheme _textTheme({required Color baseColor}) {
  // ... (código existente)
    final baseTextTheme = const TextTheme().apply(
      bodyColor: baseColor,
      displayColor: baseColor,
    );

    return baseTextTheme.copyWith(
      displaySmall: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: baseColor.withOpacity(0.7), 
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        color: baseColor.withOpacity(0.7),
      ),
      // --- AÑADE ESTE NUEVO ESTILO PARA "EMAIL" Y "PASSWORD" ---
      labelMedium: TextStyle(
        fontSize: 14,
        color: baseColor.withOpacity(0.6),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      // --------------------------------------------------------
    );
  }
}