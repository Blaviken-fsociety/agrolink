import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';
import 'zone_register_screen.dart';
import 'user_register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailCtrl = TextEditingController();
    TextEditingController passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Correo electrónico', controller: emailCtrl),
            const SizedBox(height: 10),
            CustomInput(label: 'Contraseña', controller: passCtrl, obscureText: true),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Ingresar',
              onPressed: () async {
                final user = await AuthService().login(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                );
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ZoneRegisterScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciales inválidas')),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserRegisterScreen()),
              ),
              child: const Text('¿No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}