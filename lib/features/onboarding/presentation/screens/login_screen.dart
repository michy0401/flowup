// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      // Usamos ListView para evitar desbordes (overflow) en pantallas pequeñas
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            // --- Título ---
            // Espacio superior para centrar verticalmente (ajustar al gusto)
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            
            // ----- INICIO DEL CAMBIO -----
            // Reemplazamos el 'Text' por el 'Image.asset'
            Image.asset(
              'assets/images/logo.png', // La ruta a tu logo
              height: MediaQuery.of(context).size.height * 0.15, // 15% de la altura
            ),
            // ----- FIN DEL CAMBIO -----
            
            const SizedBox(height: 48), // Espacio después del título

            // --- Formulario de Login ---
            _LoginForm(), // Widget privado para el formulario

            const SizedBox(height: 24),

            // --- Enlace de Registro ---
            Text.rich(
              TextSpan(
                style: textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Register Here',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    // Permite hacer clic en el texto
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navegación a la pantalla de registro
                        context.push('/register');
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario de Login ---
// (El resto del archivo sigue exactamente igual)
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  // late final TextEditingController _emailController;
  // late final TextEditingController _passwordController;

  // @override
  // void initState() {
  //   super.initState();
  //   _emailController = TextEditingController();
  //   _passwordController = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void _submitLogin() {
    // Por ahora, solo es visual.
    // Aquí iría la lógica de Riverpod (ej. ref.read(authProvider.notifier).login())
    if (_formKey.currentState!.validate()) {
      print('Login Válido');
      context.go('/home'); // Navegaría a home al loguearse
    }
  }

  @override
  Widget build(BuildContext cFsontext) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CAMPO EMAIL ---
          Text('EMAIL', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            // controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'hello@reallygreatsite.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Por favor, introduce un email válido';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          // --- CAMPO PASSWORD ---
          Text('PASSWORD', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            // controller: _passwordController,
            obscureText: true, // Oculta el texto de la contraseña
            decoration: const InputDecoration(
              hintText: '••••••',
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // --- BOTÓN DE LOGIN ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitLogin,
              child: const Text('Login'), // Texto corregido
            ),
          ),
        ],
      ),
    );
  }
}