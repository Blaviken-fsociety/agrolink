import 'package:flutter/material.dart';
import '../models/zone.dart';
import '../services/zone_service.dart';
import '../theme/colors.dart';

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

  String selectedCropType = '';
  String selectedStatus = '';

  final List<String> cropTypes = [
    'Hortalizas',
    'Frutas',
    'Hierbas aromáticas',
    'Plantas medicinales',
    'Cultivos hidropónicos',
    'Otros',
  ];

  final List<String> statusOptions = [
    'Preparando terreno',
    'Sembrado',
    'En crecimiento',
    'Listo para cosecha',
    'En descanso',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Registrar Zona de Cultivo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFormSection(),
            const SizedBox(height: 20),
            _buildTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              Icon(
                Icons.add_location_alt,
                color: AppColors.darkGreen,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Nueva Zona de Cultivo',
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
            'Registra una nueva zona para organizar mejor tus cultivos urbanos',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
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
            const Text(
              'Información de la Zona',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            _buildInputWithIcon(
              label: 'Nombre de la zona',
              controller: nameCtrl,
              icon: Icons.label_outline,
              hint: 'Ej: Huerto del balcón',
            ),
            const SizedBox(height: 16),
            _buildInputWithIcon(
              label: 'Tamaño (m²)',
              controller: sizeCtrl,
              icon: Icons.square_foot,
              hint: 'Ej: 2.5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Tipo de cultivo',
              value: selectedCropType,
              items: cropTypes,
              icon: Icons.eco,
              onChanged: (value) {
                setState(() {
                  selectedCropType = value ?? '';
                  cropTypeCtrl.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Estado actual',
              value: selectedStatus,
              items: statusOptions,
              icon: Icons.track_changes,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value ?? '';
                  statusCtrl.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveZone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Guardar Zona',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildInputWithIcon({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.softBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGreen),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.greyText),
              prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.softBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGreen),
          ),
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text(
              'Seleccionar...',
              style: TextStyle(color: AppColors.greyText),
            ),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consejos para tu Nueva Zona',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipItem(
              '📏',
              'Mide bien tu espacio',
              'Calcula el área disponible para optimizar la siembra',
            ),
            _buildTipItem(
              '☀️',
              'Considera la luz solar',
              'Asegúrate de que reciba al menos 6 horas de luz',
            ),
            _buildTipItem(
              '💧',
              'Planifica el riego',
              'Ten en cuenta el acceso al agua para tu nueva zona',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveZone() async {
    if (nameCtrl.text.trim().isEmpty ||
        sizeCtrl.text.trim().isEmpty ||
        selectedCropType.isEmpty ||
        selectedStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final zone = Zone(
      id: '',
      name: nameCtrl.text.trim(),
      size: double.tryParse(sizeCtrl.text.trim()) ?? 0.0,
      cropType: selectedCropType,
      status: selectedStatus,
    );

    try {
      await zoneService.addZone(zone);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Zona registrada exitosamente'),
            ],
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Limpiar formulario
      nameCtrl.clear();
      sizeCtrl.clear();
      setState(() {
        selectedCropType = '';
        selectedStatus = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la zona'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    sizeCtrl.dispose();
    cropTypeCtrl.dispose();
    statusCtrl.dispose();
    super.dispose();
  }
}
