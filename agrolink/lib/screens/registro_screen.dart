import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskEnrollmentScreen extends StatefulWidget {
  final String? zoneId;
  final String? zoneName;

  const TaskEnrollmentScreen({super.key, this.zoneId, this.zoneName});

  @override
  State<TaskEnrollmentScreen> createState() => _TaskEnrollmentScreenState();
}

class _TaskEnrollmentScreenState extends State<TaskEnrollmentScreen> {
  final TaskService taskService = TaskService();
  String selectedFilter = 'Todas';

  final List<String> filterOptions = ['Todas', 'Disponibles', 'Mis Tareas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text(
          widget.zoneName != null
              ? 'Inscripción - ${widget.zoneName}'
              : 'Inscripción a Tareas',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterSection(),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream:
                  widget.zoneId != null
                      ? taskService.getTasksByZone(widget.zoneId!)
                      : taskService.getAllTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                if (!snapshot.hasData) {
                  return _buildLoadingState();
                }

                final allTasks = snapshot.data!;
                final filteredTasks = _filterTasks(allTasks);

                if (filteredTasks.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTasksList(filteredTasks);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.how_to_reg, color: AppColors.darkGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'Inscripción a Tareas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.zoneId != null
                ? 'Inscríbete y registra horas en tareas de esta zona'
                : 'Inscríbete y registra horas de trabajo en las tareas disponibles',
            style: const TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              filterOptions.map((filter) {
                final isSelected = selectedFilter == filter;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.lightGreen,
                    checkmarkColor: AppColors.primaryGreen,
                    labelStyle: TextStyle(
                      color:
                          isSelected
                              ? AppColors.primaryGreen
                              : AppColors.greyText,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            isSelected
                                ? AppColors.primaryGreen
                                : AppColors.lightGreen,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _buildTaskCard(task);
        },
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool isEnrolled = _isUserEnrolled(task);

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
            // Header de la tarea
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTaskTypeColor(task.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTaskTypeIcon(task.type),
                    color: _getTaskTypeColor(task.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.type,
                        style: TextStyle(
                          fontSize: 14,
                          color: _getTaskTypeColor(task.type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(task.status),
              ],
            ),

            const SizedBox(height: 16),

            // Información de zona
            _buildInfoItem(
              icon: Icons.location_on,
              label: 'Zona',
              value: task.zoneName,
            ),

            const SizedBox(height: 16),

            // Descripción si existe
            if (task.description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Estado de inscripción y horas
            if (isEnrolled) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Inscrito - Horas registradas: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_getUserHours(task)} hrs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botones de acción
            Row(
              children: [
                if (!isEnrolled && task.status != 'Completada')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showEnrollmentDialog(task),
                      icon: const Icon(Icons.person_add, size: 16),
                      label: const Text('Inscribirme'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (isEnrolled) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showHoursDialog(task),
                      icon: const Icon(Icons.access_time, size: 16),
                      label: const Text('Registrar Horas'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
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
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 16),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.greyText,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
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
      case 'pendiente':
        chipColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      case 'en progreso':
        chipColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        break;
      case 'completada':
        chipColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
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
            'Cargando tareas...',
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
            'Error al cargar las tareas',
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
                Icons.assignment_ind,
                size: 60,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedFilter == 'Todas'
                  ? 'No hay tareas disponibles'
                  : selectedFilter == 'Disponibles'
                  ? 'No hay tareas disponibles para inscripción'
                  : 'No estás inscrito en ninguna tarea',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Revisa más tarde o consulta con el administrador sobre nuevas tareas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.greyText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares
  IconData _getTaskTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'siembra':
        return Icons.eco;
      case 'riego':
        return Icons.water_drop;
      case 'poda':
        return Icons.content_cut;
      case 'limpieza':
        return Icons.cleaning_services;
      case 'cosecha':
        return Icons.agriculture;
      case 'fertilización':
        return Icons.science;
      case 'control de plagas':
        return Icons.bug_report;
      case 'mantenimiento':
        return Icons.build;
      default:
        return Icons.task;
    }
  }

  Color _getTaskTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'siembra':
        return Colors.green;
      case 'riego':
        return Colors.blue;
      case 'poda':
        return Colors.orange;
      case 'limpieza':
        return Colors.purple;
      case 'cosecha':
        return Colors.amber;
      case 'fertilización':
        return Colors.brown;
      case 'control de plagas':
        return Colors.red;
      case 'mantenimiento':
        return Colors.grey;
      default:
        return AppColors.primaryGreen;
    }
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (selectedFilter == 'Todas') return tasks;

    return tasks.where((task) {
      switch (selectedFilter) {
        case 'Disponibles':
          return !_isUserEnrolled(task) && task.status != 'Completada';
        case 'Mis Tareas':
          return _isUserEnrolled(task);
        default:
          return true;
      }
    }).toList();
  }

  // Verificar si el usuario está inscrito en la tarea
  bool _isUserEnrolled(Task task) {
    // Aquí deberías verificar en Firebase si el usuario actual está inscrito
    // Por ahora retorno false, pero debes implementar la lógica real
    return false; // TODO: Implementar verificación real con Firebase
  }

  // Obtener las horas del usuario para una tarea
  double _getUserHours(Task task) {
    // Aquí deberías obtener las horas registradas del usuario desde Firebase
    // Por ahora retorno 0, pero debes implementar la lógica real
    return 0.0; // TODO: Implementar obtención real de horas desde Firebase
  }

  // Mostrar diálogo de inscripción
  Future<void> _showEnrollmentDialog(Task task) async {
    final TextEditingController hoursController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inscribirse a la Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarea: ${task.title}'),
              const SizedBox(height: 16),
              const Text('¿Cuántas horas planeas trabajar en esta tarea?'),
              const SizedBox(height: 8),
              TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Horas a trabajar',
                  suffixText: 'hrs',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (hoursController.text.isNotEmpty) {
                  Navigator.of(context).pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Inscribirme'),
            ),
          ],
        );
      },
    );

    if (result == true && hoursController.text.isNotEmpty) {
      await _enrollInTask(task, double.tryParse(hoursController.text) ?? 0);
    }
  }

  // Mostrar diálogo para registrar horas
  Future<void> _showHoursDialog(Task task) async {
    final TextEditingController hoursController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Horas Trabajadas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarea: ${task.title}'),
              const SizedBox(height: 16),
              const Text('¿Cuántas horas trabajaste hoy?'),
              const SizedBox(height: 8),
              TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Horas trabajadas',
                  suffixText: 'hrs',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (hoursController.text.isNotEmpty) {
                  Navigator.of(context).pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );

    if (result == true && hoursController.text.isNotEmpty) {
      await _registerHours(task, double.tryParse(hoursController.text) ?? 0);
    }
  }

  // Inscribirse en una tarea
  Future<void> _enrollInTask(Task task, double hours) async {
    try {
      // TODO: Implementar la inscripción en Firebase
      // await taskService.enrollUserInTask(task.id, currentUserId, hours);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Te has inscrito exitosamente en la tarea!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {}); // Refrescar la UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al inscribirse en la tarea'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Registrar horas trabajadas
  Future<void> _registerHours(Task task, double hours) async {
    try {
      // TODO: Implementar el registro de horas en Firebase
      // await taskService.registerUserHours(task.id, currentUserId, hours);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Horas registradas exitosamente!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {}); // Refrescar la UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar las horas'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
