// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      // Usamos un AppBar para tener la flecha de "atrás" automáticamente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Ajusta el color del icono de "atrás"
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground), 
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            // --- Título ---
            Text(
              'Create New Account',
              textAlign: TextAlign.center,
              style: textTheme.displaySmall?.copyWith(
                color: theme.primaryColor,
                fontSize: 32, // Un poco más pequeño que el de Login
              ),
            ),
            const SizedBox(height: 32), // Espacio después del título

            // --- Formulario de Registro ---
            const _RegisterForm(), // Widget privado para el formulario

            const SizedBox(height: 24),

            // --- Enlace de Login ---
            Text.rich(
              TextSpan(
                style: textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'Already Registered? '),
                  TextSpan(
                    text: 'Log in here.',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    // Permite hacer clic en el texto
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navegación a la pantalla de login
                        // Usamos context.go para asegurar que vamos a esa ruta
                        context.go('/login');
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32), // Espacio inferior
          ],
        ),
      ),
    );
  }
}

// --- Widget Privado: Formulario de Registro ---
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para poder leer y SETEAR el texto
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    // Siempre limpia los controladores
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- Lógica para mostrar el Date Picker ---
  Future<void> _selectDate() async {
    // Oculta el teclado si está abierto
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Límite de fecha inferior
      lastDate: DateTime.now(),  // Límite de fecha superior (hoy)
    );

    if (picked != null) {
      // Formateamos la fecha (ej. 25/12/2025)
      // (Para un formato más robusto, se usa el paquete 'intl')
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  void _submitRegister() {
    // Validamos el formulario
    if (_formKey.currentState!.validate()) {
      print('Registro Válido');
      // Aquí iría la lógica de Riverpod
      // final name = _nameController.text;
      // final email = _emailController.text;
      // ...etc.
      // context.go('/home'); // Navegaría a home al registrarse
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CAMPO NAME ---
          Text('NAME', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Jiara Martins',
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu nombre';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // --- CAMPO EMAIL ---
          Text('EMAIL', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
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
            controller: _passwordController,
            obscureText: true,
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
          const SizedBox(height: 24),

          // --- CAMPO DATE OF BIRTH ---
          Text('DATE OF BIRTH', style: textTheme.labelMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dateController, // Usamos el controlador
            readOnly: true, // Hacemos que no se pueda escribir
            decoration: const InputDecoration(
              hintText: 'Select your birth date', // Placeholder corregido
              suffixIcon: Icon(Icons.calendar_today), // Icono
            ),
            onTap: _selectDate, // <--- La magia está aquí
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, selecciona tu fecha de nacimiento';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // --- BOTÓN DE REGISTRO ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitRegister,
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}