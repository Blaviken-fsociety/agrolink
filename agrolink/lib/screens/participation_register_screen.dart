import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ParticipationRegisterScreen extends StatelessWidget {
  const ParticipationRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Participación'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInput('Nombre del participante'),
            const SizedBox(height: 20),
            _buildInput('Zona'),
            const SizedBox(height: 20),
            _buildInput('Actividad realizada'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Guardar participación
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