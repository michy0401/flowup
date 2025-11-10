// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- TU PALETA ---
  static const Color darkBackground = Color(0xFF192632);
  static const Color greenSuccess = Color(0xFF38CF3A);
  static const Color bluePrimary = Color(0xFF3244E4);
  static const Color black = Color(0xFF000000);
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color redError = Color(0xFFE62323);
  static const Color amberWarning = Color(0xFFF59E0B);
  static const Color brownAccent = Color(0xFFBE8662);

  // --- ROLES SEMÁNTICOS (Nuestra asignación) ---

  // Tema Claro
  static const Color lightPrimary = bluePrimary;
  static const Color lightOnPrimary = lightBackground;
  static const Color lightSecondary = brownAccent;
  static const Color lightSurface = Colors.white; // Para Cards
  static const Color lightOnSurface = black;
  static const Color lightBg = lightBackground;
  static const Color lightOnBg = black;
  static const Color lightError = redError;
  static const Color lightSuccess = greenSuccess;

  // Tema Oscuro
  static const Color darkPrimary = bluePrimary;
  static const Color darkOnPrimary = lightBackground;
  static const Color darkSecondary = brownAccent;
  static const Color darkSurface = Color(0xFF2A3B4A); // Un poco más claro que el fondo
  static const Color darkOnSurface = lightBackground;
  static const Color darkBg = darkBackground;
  static const Color darkOnBg = lightBackground;
  static const Color darkError = redError;
  static const Color darkSuccess = greenSuccess;
}