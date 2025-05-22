import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ZoneListScreen extends StatelessWidget {
  const ZoneListScreen({super.key});

  final List<String> zones = const [
    'Zona Norte - Sucre',
    'Zona Centro - Bolívar',
    'Zona Sur - Córdoba',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text('Lista de Zonas'),
      ),
      body: ListView.builder(
        itemCount: zones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              zones[index],
              style: const TextStyle(color: AppColors.greyText),
            ),
            leading: const Icon(Icons.agriculture, color: AppColors.primaryGreen),
          );
        },
      ),
    );
  }
}