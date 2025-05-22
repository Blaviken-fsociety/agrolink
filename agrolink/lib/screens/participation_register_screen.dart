import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class ParticipationRegisterScreen extends StatelessWidget {
  const ParticipationRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de participación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Parcela: La Esperanza\nTamaño: 0.1 ha\nCultivo: Tomate'),
            const SizedBox(height: 20),
            const Text('Participantes inscritos:'),
            const Text('• Juan Perez - Limpieza'),
            const Text('• Ricardo Ortiz - Riego'),
            const SizedBox(height: 20),
            const Text('Tareas:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                RadioButtonOption('Siembra'),
                RadioButtonOption('Riego'),
                RadioButtonOption('Poda'),
                RadioButtonOption('Limpieza'),
              ],
            ),
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

class RadioButtonOption extends StatelessWidget {
  final String label;
  const RadioButtonOption(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(value: label, groupValue: null, onChanged: (_) {}),
        Text(label),
      ],
    );
  }
}