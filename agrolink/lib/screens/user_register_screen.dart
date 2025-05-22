import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Correo electrónico', controller: emailCtrl),
            const SizedBox(height: 10),
            CustomInput(label: 'Contraseña', controller: passCtrl, obscureText: true),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Registrar',
              onPressed: () async {
                final user = await AuthService().registerUser(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                );
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro fallido')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}