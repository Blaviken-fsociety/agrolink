import 'package:flutter/material.dart';
import '../theme/colors.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInput('Nombre'),
            const SizedBox(height: 20),
            _buildInput('Correo electrónico'),
            const SizedBox(height: 20),
            _buildInput('Contraseña', obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Guardar usuario
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}