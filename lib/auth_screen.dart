import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proyecto_final_01/main.dart'; // Importar colores


// Widget que representa la Pantalla de Inicio de Sesión o Registro (Login / Sign Up)
class AuthScreen extends StatefulWidget {
  // Callback que se ejecuta cuando el inicio de sesión/registro es exitoso
  final VoidCallback onLoginSuccess;

  const AuthScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// Enum para manejar el estado entre Iniciar Sesión y Crear Cuenta
enum AuthMode { login, register }

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  
  // Controladores de texto
  final TextEditingController _emailController = TextEditingController(text: 'tu@email.com');
  final TextEditingController _passwordController = TextEditingController(text: '*********');
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  // Función para cambiar entre modos Login y Register
  void _toggleAuthMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login ? AuthMode.register : AuthMode.login;
    });
  }

  // Simulación de envío del formulario
  void _submitAuthForm() async { // Convertido a async para usar await
    // Aquí iría la lógica real de Firebase
    setState(() {
      _isLoading = true;
    });

    // Simulación de API call con éxito
    await Future.delayed(const Duration(seconds: 2));

    // Buena práctica: Comprobar si el widget sigue "montado" antes de navegar.
    // Esto evita errores si el usuario vuelve atrás mientras la carga está en progreso.
    if (!mounted) return;

    // Llama al callback de éxito para navegar al Dashboard
    widget.onLoginSuccess();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- Lógica de Responsividad ---
    // Obtenemos la altura de la pantalla para ajustar el espaciado.
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700; // Umbral para pantallas pequeñas

    // Ajustamos valores basados en el tamaño de la pantalla
    final double verticalPadding = isSmallScreen ? 16.0 : 32.0;

    final bool isLogin = _authMode == AuthMode.login;
    final String cardTitle = isLogin ? 'Iniciar Sesión' : 'Crear Cuenta';
    final String cardSubtitle = isLogin
        ? 'Accede a tu cuenta para gestionar tu dinero'
        : 'Únete a FlowUp y toma control de tus finanzas';
    final String ctaButtonText = isLogin ? 'Iniciar Sesión' : 'Crear Cuenta';
    final String toggleText = isLogin ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?';
    final String toggleActionText = isLogin ? 'Regístrate' : 'Inicia sesión';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Barra superior con botón de regreso y logo central
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Desactiva la flecha por defecto
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: theme.colorScheme.onBackground),
          onPressed: () {
            // Permite volver a la pantalla anterior (WelcomeScreen)
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.arrowUp, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              'FlowUp',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // Spacer para centrar el título si hay un Leading (o usar un Stack, pero este es más simple)
        actions: const [SizedBox(width: 48)], 
      ),
      body: Center(
        // CLAVE: Limitar el ancho máximo en pantallas grandes
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(verticalPadding), // Padding responsivo
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Título y Subtítulo ---
                    Text( // Título
                      cardTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text( // Subtítulo
                      cardSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: verticalPadding),

                    // --- Campos de Nombre y Apellido (Solo en modo Register) ---
                    if (!isLogin) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                                ),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _nameController,
                                  hint: 'Nombre',
                                  keyboardType: TextInputType.name,
                                  icon: LucideIcons.user,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Apellido',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                                ),
                                const SizedBox(height: 8),
                                _buildTextField(controller: _lastnameController, hint: 'Apellido', keyboardType: TextInputType.name),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  
                    // --- Campo de Email ---
                    Text(
                      'Correo electrónico',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'tu@email.com',
                      keyboardType: TextInputType.emailAddress,
                      icon: LucideIcons.mail,
                    ),
                    const SizedBox(height: 16),

                    // --- Campo de Contraseña ---
                    Text(
                      'Contraseña',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordField(
                      controller: _passwordController,
                      hint: '•••••••••',
                    ),
                    
                    // --- Campo de Confirmación (Solo en modo Register) ---
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Confirmar contraseña',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hint: '•••••••••',
                      ),
                    ],
                    
                    SizedBox(height: verticalPadding), // Espaciado responsivo

                    // --- Botón CTA (Comenzar) ---
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitAuthForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        shadowColor: primaryBlue.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              ctaButtonText,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                    
                    SizedBox(height: verticalPadding), // Espaciado responsivo

                    // --- Alternar Modo (Regístrate / Inicia Sesión) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( // Texto de alternancia
                          toggleText,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: _toggleAuthMode,
                          child: Text(
                            toggleActionText,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // --- Olvidaste tu Contraseña (Solo en modo Login) ---
                    if (isLogin)
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar navegación a la pantalla de recuperación
                          print('Recuperar contraseña');
                        },
                        child: Text( // Olvidaste contraseña
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8)),
                        ),
                      ),
                    
                    // --- Términos y Condiciones (Solo en modo Register) ---
                    if (!isLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text.rich(
                          TextSpan( // Términos y condiciones
                            text: 'Al crear una cuenta, aceptas nuestros ',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                            children: [
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
                                // Aquí puedes agregar un GestureRecognizer si necesitas un enlace
                              ),
                              const TextSpan(text: ' y '),
                              TextSpan(
                                text: 'Política de Privacidad',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBlue),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para campos de texto normales
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: icon != null ? Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20) : null,
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }

  // Widget auxiliar para campos de contraseña
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? LucideIcons.eye : LucideIcons.eyeOff,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
