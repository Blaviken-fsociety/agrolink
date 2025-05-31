import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../theme/colors.dart';
import 'add_task_screen.dart'; // Importar la nueva pantalla

class TaskListScreen extends StatefulWidget {
  final String? zoneId;
  final String? zoneName;
  
  const TaskListScreen({
    super.key,
    this.zoneId,
    this.zoneName,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService taskService = TaskService();
  String selectedFilter = 'Todas';
  
  final List<String> filterOptions = [
    'Todas',
    'Pendientes',
    'En progreso',
    'Completadas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text(
          widget.zoneName != null 
            ? 'Tareas - ${widget.zoneName}'
            : 'Mis Tareas de Cultivo',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () => _navigateToAddTask(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterSection(),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: widget.zoneId != null 
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(),
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
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
              Icon(Icons.task_alt, color: AppColors.darkGreen, size: 28),
              SizedBox(width: 12),
              Text(
                'Gestión de Tareas',
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
              ? 'Organiza las tareas específicas de esta zona'
              : 'Administra todas las tareas de tus zonas de cultivo',
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
          children: filterOptions.map((filter) {
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
                  color: isSelected ? AppColors.primaryGreen : AppColors.greyText,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryGreen : AppColors.lightGreen,
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

            // Información de zona y responsable
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.location_on,
                    label: 'Zona',
                    value: task.zoneName,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.person,
                    label: 'Responsable',
                    value: task.assignedTo.isNotEmpty ? task.assignedTo : 'Sin asignar',
                  ),
                ),
              ],
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

            // Botones de acción
            Row(
              children: [
                if (task.status != 'Completada')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateTaskStatus(task),
                      icon: Icon(
                        task.status == 'Pendiente' 
                          ? Icons.play_arrow 
                          : Icons.check,
                        size: 16,
                      ),
                      label: Text(
                        task.status == 'Pendiente' 
                          ? 'Iniciar' 
                          : 'Completar',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (task.status != 'Completada') const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editTask(task),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Editar', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.greyText,
                      side: const BorderSide(color: AppColors.lightGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Botón de eliminar
                OutlinedButton.icon(
                  onPressed: () => _showDeleteConfirmation(task),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Eliminar', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                Icons.assignment_add,
                size: 60,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedFilter == 'Todas' 
                ? 'No hay tareas registradas'
                : 'No hay tareas ${selectedFilter.toLowerCase()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Comienza creando tareas para organizar mejor el cuidado de tus cultivos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.greyText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddTask(),
              icon: const Icon(Icons.add),
              label: const Text('Crear Primera Tarea'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        case 'Pendientes':
          return task.status == 'Pendiente';
        case 'En progreso':
          return task.status == 'En progreso';
        case 'Completadas':
          return task.status == 'Completada';
        default:
          return true;
      }
    }).toList();
  }

  // Navegación a la pantalla de agregar tarea
  Future<void> _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          preselectedZoneId: widget.zoneId,
          preselectedZoneName: widget.zoneName,
        ),
      ),
    );

    // Si se creó una tarea exitosamente, mostrar mensaje
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Tarea creada exitosamente!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Actualizar estado de la tarea
  Future<void> _updateTaskStatus(Task task) async {
    try {
      String newStatus;
      String message;
      
      if (task.status == 'Pendiente') {
        newStatus = 'En progreso';
        message = 'Tarea iniciada';
      } else {
        newStatus = 'Completada';
        message = 'Tarea completada';
      }
      
      // Llamar al servicio para actualizar el estado
      await taskService.updateTaskStatus(task.id, newStatus);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar la tarea'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Editar tarea
  Future<void> _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          preselectedZoneId: task.zoneId,
          preselectedZoneName: task.zoneName,
          taskToEdit: task, // Pasar la tarea para editarla
        ),
      ),
    );

    // Si se editó la tarea exitosamente, mostrar mensaje
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Tarea actualizada exitosamente!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Mostrar confirmación de eliminación
  Future<void> _showDeleteConfirmation(Task task) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: Text('¿Estás seguro de que deseas eliminar la tarea "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deleteTask(task);
    }
  }

  // Eliminar tarea
  Future<void> _deleteTask(Task task) async {
    try {
      await taskService.deleteTask(task.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea eliminada exitosamente'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al eliminar la tarea'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}