import 'package:flutter/material.dart';
import '../services/zone_service.dart';
import '../models/zone.dart';
import '../theme/colors.dart';

class ZoneListScreen extends StatelessWidget {
  const ZoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zoneService = ZoneService();

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Mis Zonas de Cultivo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<Zone>>(
              stream: zoneService.getZones(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                if (!snapshot.hasData) {
                  return _buildLoadingState();
                }

                final zones = snapshot.data!;

                if (zones.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildZonesList(zones);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.landscape, color: AppColors.darkGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'Zonas Registradas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Administra y visualiza todas tus zonas de cultivo urbano',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildZonesList(List<Zone> zones) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: zones.length,
        itemBuilder: (context, index) {
          final zone = zones[index];
          return _buildZoneCard(zone, index);
        },
      ),
    );
  }

  Widget _buildZoneCard(Zone zone, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la zona
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.greenGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zone.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${zone.size.toStringAsFixed(1)} m²',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(zone.status),
              ],
            ),

            const SizedBox(height: 16),

            // Información detallada
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.eco,
                    label: 'Cultivo',
                    value: zone.cropType,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.square_foot,
                    label: 'Área',
                    value: '${zone.size.toStringAsFixed(1)} m²',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Estado detallado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGreen),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.track_changes,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estado: ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  Text(
                    zone.status,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'preparando terreno':
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'sembrado':
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'en crecimiento':
        chipColor = AppColors.lightGreen;
        textColor = AppColors.primaryGreen;
        break;
      case 'listo para cosecha':
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'en descanso':
        chipColor = Colors.grey.shade200;
        textColor = Colors.grey.shade600;
        break;
      default:
        chipColor = AppColors.lightGreen;
        textColor = AppColors.primaryGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando zonas...',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Error al cargar las zonas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verifica tu conexión e intenta nuevamente',
            style: TextStyle(fontSize: 14, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.greenGradient,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.add_location_alt,
                size: 60,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No hay zonas registradas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Comienza registrando tu primera zona de cultivo para organizar mejor tu huerto urbano',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.greyText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Consejo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Registra zonas separadas por tipo de cultivo o ubicación para mejor organización',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.greyText),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
