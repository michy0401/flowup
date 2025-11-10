// lib/core/constants/api_constants.dart

/// API configuration constants
class ApiConstants {
  // Base URL - Cambiar por tu URL del backend
  static const String baseUrl = 'http://localhost:8000';

  // API endpoints
  static const String apiPrefix = '/api';

  // Auth endpoints
  static const String authRegister = '$apiPrefix/auth/register';
  static const String authLogin = '$apiPrefix/auth/login';
  static const String authForgotPassword = '$apiPrefix/auth/forgot-password';
  static const String authResetPassword = '$apiPrefix/auth/reset-password';

  // Transaction endpoints
  static const String transactions = '$apiPrefix/transactions';

  // Goals endpoints
  static const String goals = '$apiPrefix/goals';

  // Income endpoints (Ingresos)
  static const String ingresos = '$apiPrefix/ingresos';
  static const String ingresosSearch = '$apiPrefix/ingresos/search';
  static const String ingresosTotal = '$apiPrefix/ingresos/total';

  // Expense endpoints (Gastos)
  static const String gastos = '$apiPrefix/gastos';
  static const String gastosSearch = '$apiPrefix/gastos/search';
  static const String gastosTotal = '$apiPrefix/gastos/total';

  // Savings endpoints (Ahorros)
  static const String ahorros = '$apiPrefix/ahorros';

  // Investment endpoints (Inversiones)
  static const String inversiones = '$apiPrefix/inversiones';
  static const String inversionesSearch = '$apiPrefix/inversiones/search';
  static const String inversionesTotal = '$apiPrefix/inversiones/total';

  // Category endpoints (Categorías)
  static const String categorias = '$apiPrefix/categorias';

  // Dashboard endpoints
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardChartData = '/dashboard/chart-data';

  // HTTP headers
  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
