import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController phoneCtrl = TextEditingController();
    final TextEditingController zoneCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();
    final TextEditingController confirmPassCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Nombres y apellidos', controller: nameCtrl),
            const SizedBox(height: 10),
            CustomInput(label: 'Correo electrónico', controller: emailCtrl),
            const SizedBox(height: 10),
            CustomInput(label: 'Teléfono', controller: phoneCtrl),
            const SizedBox(height: 10),
            CustomInput(label: 'Zona de residencia o cercanía', controller: zoneCtrl),
            const SizedBox(height: 10),
            CustomInput(
              label: 'Contraseña',
              controller: passCtrl,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            CustomInput(
              label: 'Confirmación contraseña',
              controller: confirmPassCtrl,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Registrarse',
              onPressed: () async {
                if (passCtrl.text.trim() != confirmPassCtrl.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Las contraseñas no coinciden')),
                  );
                  return;
                }

                final user = await AuthService().registerUser(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  zone: zoneCtrl.text.trim(),
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
