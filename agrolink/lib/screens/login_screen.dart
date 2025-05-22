import 'package:flutter/material.dart';
import '../theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AgroLink',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Digite usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Digite contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navegar al registro de usuario
              },
              child: const Text('¿No tiene una cuenta? Cree una.'),
            ),
          ],
        ),
      ),
    );
  }
}