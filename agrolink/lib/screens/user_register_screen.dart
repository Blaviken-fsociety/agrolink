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
    final ValueNotifier<List<String>> availabilityCtrl =
        ValueNotifier<List<String>>([]);

    final List<String> daysOfWeek = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
    ];

    void showMultiSelectDialog() async {
      final List<String> tempSelected = List.from(availabilityCtrl.value);

      final selectedDays = await showDialog<List<String>>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Selecciona días de disponibilidad'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        daysOfWeek.map((day) {
                          return CheckboxListTile(
                            title: Text(day),
                            value: tempSelected.contains(day),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  if (!tempSelected.contains(day)) {
                                    tempSelected.add(day);
                                  }
                                } else {
                                  tempSelected.remove(day);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, tempSelected),
                    child: const Text('Aceptar'),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, availabilityCtrl.value),
                    child: const Text('Cancelar'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (selectedDays != null) {
        availabilityCtrl.value = selectedDays;
      }
    }

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
            CustomInput(
              label: 'Zona de residencia o cercanía',
              controller: zoneCtrl,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: showMultiSelectDialog,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Días de disponibilidad',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  availabilityCtrl.value.isEmpty
                      ? 'Selecciona los días'
                      : availabilityCtrl.value.join(', '),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children:
                  availabilityCtrl.value.map((day) {
                    return Chip(
                      label: Text(day),
                      onDeleted: () {
                        availabilityCtrl.value =
                            availabilityCtrl.value
                                .where((d) => d != day)
                                .toList();
                      },
                    );
                  }).toList(),
            ),
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
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden'),
                    ),
                  );
                  return;
                }
                if (availabilityCtrl.value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Selecciona al menos un día de disponibilidad',
                      ),
                    ),
                  );
                  return;
                }

                final user = await AuthService().registerUser(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  zone: zoneCtrl.text.trim(),
                  availability: availabilityCtrl.value,
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
