import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class ZoneRegisterScreen extends StatelessWidget {
  const ZoneRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de parcela')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Nombre'),
            const SizedBox(height: 12),
            CustomInput(label: 'Tamaño en hectáreas'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Hortalizas y vegetales', child: Text('Hortalizas y vegetales')),
                DropdownMenuItem(value: 'Cereales', child: Text('Cereales')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Tomate', child: Text('Tomate')),
                DropdownMenuItem(value: 'Lechuga', child: Text('Lechuga')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Tipo de cultivo'),
            ),
            const SizedBox(height: 12),
            CustomInput(label: 'Estado actual'),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Registrar',
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