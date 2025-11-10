# 📚 Documentación de Arquitectura - FlowUp

## 📖 Índice
1. [¿Qué es Riverpod?](#qué-es-riverpod)
2. [¿Cómo funcionan los Providers?](#cómo-funcionan-los-providers)
3. [¿Cómo se conectan las pantallas a los Providers?](#cómo-se-conectan-las-pantallas-a-los-providers)
4. [¿Cómo se hacen las llamadas a la API?](#cómo-se-hacen-las-llamadas-a-la-api)
5. [¿Qué es GoRouter y cómo funciona?](#qué-es-gorouter)
6. [Arquitectura del Proyecto](#arquitectura-del-proyecto)

---

## 🎯 ¿Qué es Riverpod?

**Riverpod** es una librería de gestión de estado para Flutter. Es la evolución de Provider y ofrece:
- ✅ **Type-safety**: Detecta errores en tiempo de compilación
- ✅ **Sin context**: No necesitas BuildContext para acceder al estado
- ✅ **Testeable**: Fácil de probar
- ✅ **Inmutable**: Estado predecible
- ✅ **Modular**: Código desacoplado

### ¿Cómo funciona Riverpod?

Riverpod funciona con el patrón **Provider**, donde:
1. **Defines un provider** que expone datos o lógica
2. **Observas el provider** desde tus widgets
3. **El widget se reconstruye** automáticamente cuando cambia el estado

### Ejemplo de uso en el proyecto

**Archivo**: `lib/main.dart:17`
```dart
void main() {
  runApp(
    // Envolvemos toda la app en ProviderScope
    // Esto es OBLIGATORIO para usar Riverpod
    const ProviderScope(
      child: MainApp(),
    ),
  );
}
```

**Archivo**: `lib/main.dart:23`
```dart
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado del provider de tema
    // Cuando cambia, el widget se reconstruye
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FlowUp',
      themeMode: themeMode, // Usamos el valor del provider
      routerConfig: AppRouter.router,
    );
  }
}
```

**¿Dónde se usa?** En casi todos los archivos que manejan estado:
- `lib/features/auth/presentation/providers/auth_providers.dart`
- `lib/features/home/presentation/screens/home_screen.dart`
- `lib/features/onboarding/presentation/screens/login_screen.dart`

---

## 🔌 ¿Cómo funcionan los Providers?

Un **Provider** es un objeto que provee un valor o estado a los widgets. Hay diferentes tipos:

### 1. Provider - Expone valores simples

**Archivo**: `lib/core/providers/core_providers.dart:6`
```dart
/// Provider que expone el servicio de almacenamiento seguro
/// Se crea UNA SOLA VEZ y se reutiliza en toda la app
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider que expone el cliente API
/// Depende de secureStorageServiceProvider
final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return ApiClient(storageService: storageService);
});
```

### 2. StateProvider - Para estado simple y mutable

**Archivo**: `lib/main.dart:9`
```dart
/// StateProvider para manejar el tema (claro/oscuro)
/// Permite leer Y modificar el valor
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // Valor inicial
});

// Para leer el valor:
// final theme = ref.watch(themeModeProvider);

// Para modificar el valor:
// ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
```

### 3. FutureProvider - Para datos asíncronos

**Archivo**: `lib/features/home/presentation/providers/dashboard_providers.dart:25`
```dart
/// FutureProvider que obtiene el resumen del dashboard
/// Se ejecuta automáticamente cuando se observa
final dashboardSummaryProvider =
    FutureProvider<DashboardSummaryModel>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getSummary(); // Llamada asíncrona a la API
});

// Uso en un widget:
// final summaryAsync = ref.watch(dashboardSummaryProvider);
// summaryAsync.when(
//   data: (summary) => Text(summary.income),
//   loading: () => CircularProgressIndicator(),
//   error: (error, stack) => Text('Error: $error'),
// );
```

### 4. StateNotifierProvider - Para estado complejo

**Archivo**: `lib/features/auth/presentation/providers/auth_providers.dart:26`
```dart
/// StateNotifierProvider para manejar la autenticación
/// Permite manejar estado complejo con lógica de negocio
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthStateNotifier(repository: repository);
  },
);

/// El estado que maneja (puede tener múltiples propiedades)
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  // ...
}

/// El notifier que modifica el estado
class AuthStateNotifier extends StateNotifier<AuthState> {
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true); // Actualiza el estado
    // Lógica de login...
    state = state.copyWith(user: user, isAuthenticated: true, isLoading: false);
  }
}
```

---

## 🔗 ¿Cómo se conectan las pantallas a los Providers?

Para conectar una pantalla a un provider:

### Paso 1: Usa `ConsumerWidget` o `ConsumerStatefulWidget`

**Archivo**: `lib/features/home/presentation/screens/home_screen.dart:12`
```dart
// En lugar de StatelessWidget, usamos ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ↑ Nota: build() ahora recibe WidgetRef ref
    // ref nos permite observar providers

    // Observamos el provider del dashboard
    final dashboardSummaryAsync = ref.watch(dashboardSummaryProvider);

    // ...
  }
}
```

### Paso 2: Observa el provider con `ref.watch()`

Hay 3 métodos principales:

#### `ref.watch()` - Observa y reconstruye cuando cambia
```dart
// El widget se reconstruye automáticamente cuando cambia el estado
final authState = ref.watch(authStateProvider);
if (authState.isLoading) {
  return CircularProgressIndicator();
}
```

#### `ref.read()` - Lee el valor UNA vez (sin observar)
```dart
// Lee el valor sin observar cambios
// Útil para ejecutar acciones
void _handleLogin() {
  ref.read(authStateProvider.notifier).login(email: email, password: password);
}
```

#### `ref.listen()` - Escucha cambios para ejecutar side effects
```dart
ref.listen(authStateProvider, (previous, next) {
  if (next.errorMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.errorMessage!)),
    );
  }
});
```

### Ejemplo completo: Login Screen

**Archivo**: `lib/features/onboarding/presentation/screens/login_screen.dart:63`
```dart
class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends ConsumerState<_LoginForm> {
  // Controllers para los campos de texto
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Usamos ref.read() para ejecutar una acción
        await ref.read(authStateProvider.notifier).login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

        // Si el login es exitoso, navegamos
        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        // Mostramos el error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observamos el estado de autenticación
    final authState = ref.watch(authStateProvider);

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            enabled: !authState.isLoading, // Deshabilitamos si está cargando
          ),
          ElevatedButton(
            // Deshabilitamos el botón si está cargando
            onPressed: authState.isLoading ? null : _submitLogin,
            child: authState.isLoading
                ? CircularProgressIndicator()
                : Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🌐 ¿Cómo se hacen las llamadas a la API?

El proyecto sigue la **arquitectura limpia (Clean Architecture)**:

```
Presentación (UI) → Repositorio → Fuente de Datos → API
    Widget      →  Repository →  DataSource    → HTTP
```

### Flujo completo de una llamada API

#### 1. Configuración del cliente HTTP

**Archivo**: `lib/core/services/api_client.dart:65`
```dart
/// Cliente HTTP que maneja todas las peticiones
class ApiClient {
  final SecureStorageService _storageService;

  /// GET - Obtener datos
  Future<ApiResponse> get(String path, {bool requiresAuth = true}) async {
    final url = _buildUrl(path);
    final headers = await _buildHeaders(requiresAuth: requiresAuth);

    // Agrega automáticamente el token JWT si requiresAuth = true
    final response = await _httpClient.get(url, headers: headers);

    return _handleResponse(response);
  }

  /// POST - Crear datos
  Future<ApiResponse> post(String path, {Map<String, dynamic>? body}) async {
    // Similar a GET, pero con body
  }

  // PUT, PATCH, DELETE...
}
```

#### 2. Fuente de datos (Data Source)

**Archivo**: `lib/features/transactions/data/datasources/income_remote_datasource.dart:13`
```dart
/// Data Source: Responsable de hacer las llamadas HTTP
class IncomeRemoteDataSource {
  final ApiClient _apiClient;

  /// Obtener todos los ingresos
  Future<List<IncomeModel>> getAll() async {
    // Llamada GET a la API
    final response = await _apiClient.get(ApiConstants.ingresos);

    // Convertimos la respuesta JSON a modelos
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => IncomeModel.fromJson(json)).toList();
  }

  /// Crear un nuevo ingreso
  Future<IncomeModel> create({required String amount}) async {
    // Llamada POST a la API
    final response = await _apiClient.post(
      ApiConstants.ingresos,
      body: {'amount': amount},
    );

    return IncomeModel.fromJson(response.data);
  }
}
```

#### 3. Repositorio

**Archivo**: `lib/features/transactions/data/repositories/income_repository.dart:7`
```dart
/// Repository: Abstracción entre la UI y la fuente de datos
class IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  /// Obtener todos los ingresos
  Future<List<IncomeModel>> getAll() {
    // Delega al data source
    return _remoteDataSource.getAll();
  }

  /// Crear ingreso
  Future<IncomeModel> create({required String amount}) {
    return _remoteDataSource.create(amount: amount);
  }
}
```

#### 4. Provider

**Archivo**: `lib/features/transactions/presentation/providers/income_providers.dart:15`
```dart
/// Provider del repositorio
final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  final remoteDataSource = ref.watch(incomeRemoteDataSourceProvider);
  return IncomeRepository(remoteDataSource: remoteDataSource);
});

/// Provider para obtener la lista de ingresos
final incomeListProvider = FutureProvider<List<IncomeModel>>((ref) async {
  final repository = ref.watch(incomeRepositoryProvider);
  return repository.getAll(); // Llama al repositorio
});
```

#### 5. UI (Pantalla)

```dart
class IncomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el provider que hace la llamada a la API
    final incomeListAsync = ref.watch(incomeListProvider);

    return incomeListAsync.when(
      // Cuando los datos están listos
      data: (incomes) => ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          final income = incomes[index];
          return ListTile(
            title: Text(income.description ?? 'Sin descripción'),
            subtitle: Text('\$${income.amount}'),
          );
        },
      ),
      // Mientras carga
      loading: () => Center(child: CircularProgressIndicator()),
      // Si hay error
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
```

### Resumen del flujo:

1. **Widget** observa un `FutureProvider`
2. **FutureProvider** usa el `Repository`
3. **Repository** usa el `DataSource`
4. **DataSource** usa el `ApiClient`
5. **ApiClient** hace la petición HTTP con el token JWT
6. Los datos regresan por la cadena hasta el **Widget**

---

## 🧭 ¿Qué es GoRouter?

**GoRouter** es el sistema de navegación oficial de Flutter. Ofrece:
- ✅ **Navegación declarativa**: Define rutas como una configuración
- ✅ **Deep linking**: Soporte para URLs
- ✅ **Parámetros**: Pasa datos entre pantallas
- ✅ **Rutas anidadas**: Organiza mejor las rutas

### ¿Dónde se configura?

**Archivo**: `lib/core/router/app_router.dart:28`
```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Ruta inicial

    routes: [
      // Ruta raíz
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Ruta de login
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Ruta con rutas anidadas
      GoRoute(
        path: '/income',
        name: 'income',
        builder: (context, state) => const IncomeScreen(),
        routes: [
          // Subruta: /income/new
          GoRoute(
            path: 'new',
            name: 'new-income',
            builder: (context, state) => NewIncomeScreen(),
          ),
          // Subruta con parámetro: /income/:id
          GoRoute(
            path: ':id',
            name: 'income-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? 'error';
              return IncomeDetailScreen(transactionId: id);
            },
          ),
        ],
      ),
    ],
  );
}
```

### ¿Cómo se usa en la app?

**Archivo**: `lib/main.dart:31`
```dart
class MainApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FlowUp',
      // Conectamos el router a la app
      routerConfig: AppRouter.router,
    );
  }
}
```

### ¿Cómo navegar entre pantallas?

#### Navegación simple con `context.push()`

**Archivo**: `lib/features/home/presentation/screens/home_screen.dart:121`
```dart
// Navegar a una nueva pantalla (se añade al stack)
onTap: () => context.push('/income'),
```

#### Navegación con reemplazo usando `context.go()`

**Archivo**: `lib/features/onboarding/presentation/screens/login_screen.dart:98`
```dart
// Reemplazar la pantalla actual
// (útil después del login para no poder volver atrás)
context.go('/home');
```

#### Navegación con parámetros

```dart
// Parámetros en la URL
context.push('/income/abc-123-def'); // id = 'abc-123-def'

// Pasar datos complejos con 'extra'
context.push(
  '/income/new',
  extra: {'id': '123', 'amount': '100.00'},
);

// Recibir en el builder:
GoRoute(
  path: 'new',
  builder: (context, state) {
    final data = state.extra as Map<String, dynamic>?;
    return NewIncomeScreen(initialData: data);
  },
),
```

#### Regresar a la pantalla anterior

```dart
// Volver atrás
context.pop();

// Volver atrás con resultado
context.pop('resultado');
```

---

## 🏗️ Arquitectura del Proyecto

```
lib/
├── core/                           # Código compartido
│   ├── constants/
│   │   └── api_constants.dart     # URLs y constantes de la API
│   ├── providers/
│   │   └── core_providers.dart    # Providers globales
│   ├── router/
│   │   └── app_router.dart        # Configuración de rutas
│   ├── services/
│   │   ├── api_client.dart        # Cliente HTTP
│   │   └── secure_storage_service.dart # Almacenamiento seguro
│   ├── theme/
│   └── widgets/                    # Widgets reutilizables
│
└── features/                       # Características de la app
    ├── auth/                       # Autenticación
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── auth_repository.dart
    │   ├── domain/
    │   │   └── models/
    │   │       ├── user_model.dart
    │   │       └── auth_response_model.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_providers.dart
    │       └── screens/
    │
    ├── home/                       # Pantalla principal
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── dashboard_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── dashboard_repository.dart
    │   ├── domain/
    │   │   └── models/
    │   │       ├── dashboard_summary_model.dart
    │   │       └── chart_data_model.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── dashboard_providers.dart
    │       ├── screens/
    │       │   └── home_screen.dart
    │       └── widgets/
    │
    └── transactions/               # Transacciones
        ├── data/
        │   ├── datasources/
        │   │   ├── income_remote_datasource.dart
        │   │   └── expense_remote_datasource.dart
        │   └── repositories/
        │       ├── income_repository.dart
        │       └── expense_repository.dart
        ├── domain/
        │   └── models/
        │       ├── income_model.dart
        │       └── expense_model.dart
        └── presentation/
            ├── providers/
            │   ├── income_providers.dart
            │   └── expense_providers.dart
            └── screens/
```

### Capas de la arquitectura:

1. **Presentation** (Presentación)
   - Widgets y pantallas (UI)
   - Providers para estado
   - Consume repositorios

2. **Domain** (Dominio)
   - Modelos de datos
   - Entidades del negocio
   - Interfaces

3. **Data** (Datos)
   - Implementaciones de repositorios
   - Data sources (remote/local)
   - Llamadas a la API

---

## 📝 Ejemplos de código por ubicación

### 1. Provider usado en main.dart

**Ubicación**: `lib/main.dart:9-11`
```dart
// Definición del provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

// Uso del provider (línea 29)
final themeMode = ref.watch(themeModeProvider);
```

### 2. Provider usado en login_screen.dart

**Ubicación**: `lib/features/onboarding/presentation/screens/login_screen.dart:92-95`
```dart
// Ejecutar una acción (login)
await ref.read(authStateProvider.notifier).login(
  email: _emailController.text.trim(),
  password: _passwordController.text,
);

// Observar el estado (línea 117)
final authState = ref.watch(authStateProvider);
```

### 3. Provider usado en home_screen.dart

**Ubicación**: `lib/features/home/presentation/screens/home_screen.dart:19`
```dart
// Observar datos asíncronos del dashboard
final dashboardSummaryAsync = ref.watch(dashboardSummaryProvider);

// Usar los datos con .when() (línea 34)
dashboardSummaryAsync.when(
  data: (summary) => _buildSummaryGrid(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### 4. API Call en income_remote_datasource.dart

**Ubicación**: `lib/features/transactions/data/datasources/income_remote_datasource.dart:13-28`
```dart
Future<List<IncomeModel>> getAll() async {
  final response = await _apiClient.get(ApiConstants.ingresos);
  final List<dynamic> data = response.data as List<dynamic>;
  return data.map((json) => IncomeModel.fromJson(json)).toList();
}
```

### 5. GoRouter en app_router.dart

**Ubicación**: `lib/core/router/app_router.dart:54-77`
```dart
GoRoute(
  path: '/income',
  name: 'income',
  builder: (context, state) => const IncomeScreen(),
  routes: [
    GoRoute(
      path: 'new',
      name: 'new-income',
      builder: (context, state) => NewIncomeScreen(),
    ),
    GoRoute(
      path: ':id',
      name: 'income-detail',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return IncomeDetailScreen(transactionId: id);
      },
    ),
  ],
),
```

### 6. Navegación con GoRouter

**Ubicación**: `lib/features/home/presentation/screens/home_screen.dart:121`
```dart
// Push (añadir al stack)
onTap: () => context.push('/income'),

// Go (reemplazar)
context.go('/home');

// Pop (volver atrás)
context.pop();
```

---

## 🎓 Resumen para desarrolladores

### ¿Cuándo usar qué?

| Necesito... | Uso... | Ejemplo |
|-------------|--------|---------|
| Observar estado y reconstruir | `ref.watch()` | `final user = ref.watch(authStateProvider);` |
| Ejecutar una acción | `ref.read()` | `ref.read(authProvider.notifier).login();` |
| Estado simple | `StateProvider` | Tema, filtros, toggles |
| Datos de API | `FutureProvider` | Lista de productos, dashboard |
| Estado complejo con lógica | `StateNotifierProvider` | Auth, carrito de compras |
| Valores singleton | `Provider` | API client, servicios |
| Navegar a otra pantalla | `context.push()` | `context.push('/settings')` |
| Reemplazar pantalla | `context.go()` | Después del login |
| Volver atrás | `context.pop()` | Cerrar modal |

---

## 🔧 Configuración del Backend

Para que la app funcione, asegúrate de:

1. **Configurar la URL del backend**:
   - Edita `lib/core/constants/api_constants.dart`
   - Cambia `baseUrl` a la URL de tu backend
   ```dart
   static const String baseUrl = 'http://localhost:8000'; // Cambia esto
   ```

2. **Ejecutar el backend**:
   - El backend debe estar corriendo en el puerto configurado
   - Asegúrate de que los endpoints estén disponibles

3. **Ejecutar la app**:
   ```bash
   flutter pub get
   flutter run
   ```

---

## 📚 Recursos adicionales

- [Documentación oficial de Riverpod](https://riverpod.dev)
- [Documentación oficial de GoRouter](https://pub.dev/packages/go_router)
- [Clean Architecture en Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Fecha de creación**: Noviembre 2025
**Versión**: 1.0.0
