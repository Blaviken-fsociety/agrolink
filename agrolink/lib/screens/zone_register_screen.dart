import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../models/zone.dart';
import '../services/zone_service.dart';

class ZoneRegisterScreen extends StatefulWidget {
  const ZoneRegisterScreen({super.key});

  @override
  State<ZoneRegisterScreen> createState() => _ZoneRegisterScreenState();
}

class _ZoneRegisterScreenState extends State<ZoneRegisterScreen> {
  final nameCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final cropTypeCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  final ZoneService zoneService = ZoneService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Zona de Cultivo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Nombre de la zona', controller: nameCtrl),
            CustomInput(label: 'Tamaño (m²)', controller: sizeCtrl),
            CustomInput(label: 'Tipo de cultivo', controller: cropTypeCtrl),
            CustomInput(label: 'Estado actual', controller: statusCtrl),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Guardar Zona',
              onPressed: () async {
                final zone = Zone(
                  id: '',
                  name: nameCtrl.text.trim(),
                  size: double.tryParse(sizeCtrl.text.trim()) ?? 0.0,
                  cropType: cropTypeCtrl.text.trim(),
                  status: statusCtrl.text.trim(),
                );

                await zoneService.addZone(zone);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Zona registrada exitosamente')),
                );

                nameCtrl.clear();
                sizeCtrl.clear();
                cropTypeCtrl.clear();
                statusCtrl.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}