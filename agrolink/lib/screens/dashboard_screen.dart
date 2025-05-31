import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'zone_register_screen.dart';
import 'zone_list_screen.dart';
import 'task_list_screen.dart';
import 'workshops_screen.dart';
import 'statistics_screen.dart';
import 'add_task_screen.dart';
import 'login_screen.dart'; // Import the LoginScreen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Función para mostrar el diálogo de confirmación de cierre de sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.softBackground,
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(color: AppColors.greyText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.greyText),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ); // Navigate to LoginScreen
              },
              child: const Text(
                'Salir',
                style: TextStyle(color: AppColors.warning),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'AgroLink',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => _showLogoutDialog(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido a tu huerto comunitario!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Gestiona tu participación en el proyecto de agricultura urbana',
              style: TextStyle(fontSize: 16, color: AppColors.greyText),
            ),
            const SizedBox(height: 30),

            // Sección principal - Gestión
            _buildSectionTitle('Gestión de Espacios'),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _DashboardCard(
                  label: 'Registrar\nZona de Cultivo',
                  icon: Icons.add_location_alt,
                  color: AppColors.primaryGreen,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ZoneRegisterScreen(),
                        ),
                      ),
                ),
                _DashboardCard(
                  label: 'Lista de\nZonas',
                  icon: Icons.list_alt,
                  color: AppColors.success,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ZoneListScreen()),
                      ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Sección participación
            _buildSectionTitle('Participación Comunitaria'),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _DashboardCard(
                  label: 'Añadir\nTareas',
                  icon: Icons.person_outline,
                  color: AppColors.darkGreen,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTaskScreen(),
                        ),
                      ),
                ),
                _DashboardCard(
                  label: 'Tareas',
                  icon: Icons.add_task,
                  color: AppColors.darkGreen,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TaskListScreen(),
                        ),
                      ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Sección educación y estadísticas
            _buildSectionTitle('Educación y Seguimiento'),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _DashboardCard(
                  label: 'Talleres y\nEventos',
                  icon: Icons.school,
                  color: AppColors.primaryGreen,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkshopsScreen(),
                        ),
                      ),
                ),
                _DashboardCard(
                  label: 'Estadísticas\ne Impacto',
                  icon: Icons.analytics,
                  color: AppColors.success,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatisticsScreen(),
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.greyText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
