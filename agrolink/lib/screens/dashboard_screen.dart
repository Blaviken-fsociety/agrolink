import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text('AgroLink'),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _DashboardCard(label: 'Registrar Parcela', onTap: () {
            // Navegar a pantalla de registro de parcela
          }),
          _DashboardCard(label: 'Registrar Usuario', onTap: () {
            // Navegar a pantalla de registro de usuario
          }),
          _DashboardCard(label: 'Lista de Zonas', onTap: () {
            // Navegar a lista de zonas
          }),
          _DashboardCard(label: 'Registrar Participación', onTap: () {
            // Navegar a participación
          }),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.greyText,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}