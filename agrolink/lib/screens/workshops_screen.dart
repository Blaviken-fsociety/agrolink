import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({super.key});

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Educación Ambiental',
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
            _buildEducationSection(),
            const SizedBox(height: 20),
            _buildUpcomingEventsSection(),
            const SizedBox(height: 20),
            _buildResourcesSection(),
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
              Icon(Icons.school, color: AppColors.darkGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'Aprende Agricultura Urbana',
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
            'Descubre prácticas sostenibles y conocimientos básicos para cultivar en espacios urbanos',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conocimientos Básicos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 15),
        _buildEducationCard(
          'Fundamentos de Agricultura Urbana',
          'Conceptos básicos sobre cultivo en espacios urbanos',
          Icons.eco,
          [
            'Tipos de cultivos urbanos',
            'Selección de espacios',
            'Herramientas básicas',
            'Planificación de cultivos',
          ],
        ),
        const SizedBox(height: 10),
        _buildEducationCard(
          'Técnicas de Cultivo Sostenible',
          'Métodos ecológicos para maximizar la producción',
          Icons.water_drop,
          [
            'Compostaje casero',
            'Riego eficiente',
            'Control natural de plagas',
            'Rotación de cultivos',
          ],
        ),
        const SizedBox(height: 10),
        _buildEducationCard(
          'Huertos Verticales',
          'Aprovecha el espacio con técnicas innovadoras',
          Icons.vertical_align_top,
          [
            'Diseño de huertos verticales',
            'Cultivo en contenedores',
            'Sistemas hidropónicos',
            'Optimización del espacio',
          ],
        ),
      ],
    );
  }

  Widget _buildEducationCard(
    String title,
    String description,
    IconData icon,
    List<String> topics,
  ) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.primaryGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${topics.take(2).join(' • ')}${topics.length > 2 ? ' • +${topics.length - 2} más' : ''}',
              style: const TextStyle(fontSize: 12, color: AppColors.greyText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Talleres y Eventos Programados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 15),
        _buildWorkshopCard(
          'Taller de Compostaje',
          'Crea compost con residuos orgánicos',
          DateTime.now().add(const Duration(days: 5)),
          '2h',
          25,
          Icons.recycling,
          true,
        ),
        const SizedBox(height: 10),
        _buildWorkshopCard(
          'Huerto Vertical',
          'Construye tu huerto en espacios pequeños',
          DateTime.now().add(const Duration(days: 12)),
          '3h',
          15,
          Icons.agriculture,
          true,
        ),
      ],
    );
  }

  Widget _buildWorkshopCard(
    String title,
    String description,
    DateTime date,
    String duration,
    int maxParticipants,
    IconData icon,
    bool isUpcoming,
  ) {
    final isCompleted = date.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming ? AppColors.primaryGreen : AppColors.lightGreen,
          width: 1,
        ),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? AppColors.greyText
                            : AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCompleted ? 'Completado' : 'Próximo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.people, color: AppColors.primaryGreen, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$maxParticipants',
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: AppColors.greyText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryGreen,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM').format(date),
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.access_time,
                  color: AppColors.primaryGreen,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: () => _joinWorkshop(title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text(
                      'Inscribirse',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consejos Prácticos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        const SizedBox(height: 15),
        Container(
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
                _buildTipItem(
                  '💡',
                  'Mejor momento para plantar',
                  'Primavera y otoño son ideales',
                ),
                _buildTipItem(
                  '🌱',
                  'Preparación del suelo',
                  'Mezcla tierra fértil con compost',
                ),
                _buildTipItem(
                  '💧',
                  'Riego inteligente',
                  'Riega temprano o al atardecer',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  void _joinWorkshop(String workshopTitle) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Te has inscrito a: $workshopTitle'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
