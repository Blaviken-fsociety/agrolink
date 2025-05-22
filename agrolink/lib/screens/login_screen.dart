import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import 'user_register_screen.dart'; // Para navegación
import 'zone_register_screen.dart'; // Ejemplo de destino tras login

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(
              label: 'Correo electrónico',
              controller: emailController,
            ),
            const SizedBox(height: 12),
            CustomInput(
              label: 'Contraseña',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Ingresar',
              onPressed: () {
                // Aquí podrías validar el login con Firebase o API
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ZoneRegisterScreen(), // o HomeScreen si lo agregas
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserRegisterScreen(),
                  ),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}