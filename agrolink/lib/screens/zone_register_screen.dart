import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ZoneRegisterScreen extends StatelessWidget {
  const ZoneRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Parcela'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInput('Nombre de la parcela'),
            const SizedBox(height: 20),
            _buildInput('Departamento'),
            const SizedBox(height: 20),
            _buildInput('Municipio'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Guardar parcela
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}