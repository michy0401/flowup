// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      background: AppColors.lightBg,
      onBackground: AppColors.lightOnBg,
      error: AppColors.lightError,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: _textTheme(baseColor: AppColors.lightOnBg),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // --- CÓDIGO RESTAURADO ---
    elevatedButtonTheme: _elevatedButtonTheme(
      buttonColor: AppColors.lightPrimary,
      textColor: AppColors.lightOnPrimary,
    ),
    // -------------------------
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
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightBg, // Fondo normal
      selectedColor: AppColors.lightPrimary, // Color primario al seleccionar
      labelStyle: const TextStyle(color: AppColors.black),
      secondaryLabelStyle: const TextStyle(color: AppColors.lightOnPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      // selectedColorOpacity: 1, // <-- LÍNEA ELIMINADA
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      background: AppColors.darkBg,
      onBackground: AppColors.darkOnBg,
      error: AppColors.darkError,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme(baseColor: AppColors.darkOnBg),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    // --- CÓDIGO RESTAURADO ---
    elevatedButtonTheme: _elevatedButtonTheme(
      buttonColor: AppColors.darkPrimary,
      textColor: AppColors.darkOnPrimary,
    ),
    // -------------------------
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
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface, // Fondo normal
      selectedColor: AppColors.darkPrimary, // Color primario al seleccionar
      labelStyle: const TextStyle(color: AppColors.lightBackground),
      secondaryLabelStyle: const TextStyle(color: AppColors.lightOnPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey),
      ),
      // selectedColorOpacity: 1, // <-- LÍNEA ELIMINADA
    ),
  );

  // --- WIDGETS THEME (FUNCIÓN CORREGIDA) ---
  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Color buttonColor,
    required Color textColor,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // <-- Corregido
        foregroundColor: textColor, // <-- Corregido
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    );
  }
  
  // --- TEXT THEME (CORREGIDO) ---
  static TextTheme _textTheme({required Color baseColor}) {
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
      labelMedium: TextStyle(
        fontSize: 14,
        color: baseColor.withOpacity(0.6),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}