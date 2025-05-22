import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Nombres y apellidos'),
            const SizedBox(height: 12),
            CustomInput(label: 'Correo electrónico'),
            const SizedBox(height: 12),
            CustomInput(label: 'Teléfono'),
            const SizedBox(height: 12),
            CustomInput(label: 'Zona de residencia o cercanía'),
            const SizedBox(height: 12),
            CustomInput(label: 'Contraseña', obscureText: true),
            const SizedBox(height: 12),
            CustomInput(label: 'Confirmación contraseña', obscureText: true),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Registrarse',
              onPressed: () {
                // Lógica de registro
              },
            ),
          ],
        ),
      ),
    );
  }
}