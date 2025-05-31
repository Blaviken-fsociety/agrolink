import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../theme/colors.dart';

class AddTaskScreen extends StatefulWidget {
  final String? preselectedZoneId;
  final String? preselectedZoneName;
  final Task? taskToEdit;

  const AddTaskScreen({
    super.key,
    this.preselectedZoneId,
    this.preselectedZoneName,
    this.taskToEdit,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();

  // Controladores de texto
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();

  // Variables del formulario
  String _selectedType = 'Siembra';
  String _selectedPriority = 'Media';
  String _selectedStatus = 'Pendiente';
  String? _selectedZoneId;
  String? _selectedZoneName;
  DateTime _selectedDate = DateTime.now();

  // Opciones disponibles
  final List<String> _taskTypes = [
    'Siembra',
    'Riego',
    'Poda',
    'Limpieza',
    'Cosecha',
    'Fertilización',
    'Control de plagas',
    'Mantenimiento',
  ];

  final List<String> _priorities = ['Baja', 'Media', 'Alta', 'Urgente'];

  final List<String> _statuses = ['Pendiente', 'En progreso'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedZoneId != null) {
      _selectedZoneId = widget.preselectedZoneId;
      _selectedZoneName = widget.preselectedZoneName;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Nueva Tarea',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _isLoading ? null : _saveTask,
              child: Text(
                'GUARDAR',
                style: TextStyle(
                  color: _isLoading ? Colors.white54 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? _buildLoadingState()
              : SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildBasicInfoSection(),
                        const SizedBox(height: 16),
                        _buildDetailsSection(),
                        const SizedBox(height: 16),
                        _buildConfigurationSection(),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_task_rounded,
              color: AppColors.darkGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Nueva Tarea',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Organiza las actividades de tu cultivo',
                  style: TextStyle(fontSize: 14, color: AppColors.greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Información Básica',
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          // Título de la tarea
          _buildTextFormField(
            controller: _titleController,
            label: 'Título de la tarea',
            hint: 'Ej: Riego matutino sector A',
            icon: Icons.title_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El título es obligatorio';
              }
              if (value.length < 3) {
                return 'El título debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Tipo de tarea
          _buildDropdownField<String>(
            value: _selectedType,
            label: 'Tipo de tarea',
            icon: _getTaskTypeIcon(_selectedType),
            items: _taskTypes,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
            itemBuilder:
                (type) => Row(
                  children: [
                    Icon(
                      _getTaskTypeIcon(type),
                      color: _getTaskTypeColor(type),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(type, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return _buildSection(
      title: 'Detalles',
      icon: Icons.description_rounded,
      child: Column(
        children: [
          // Descripción
          _buildTextFormField(
            controller: _descriptionController,
            label: 'Descripción (opcional)',
            hint: 'Describe los detalles de la tarea...',
            icon: Icons.description_rounded,
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: 16),

          // Zona de cultivo
          _buildZoneSelector(),
          const SizedBox(height: 16),

          // Responsable
          _buildTextFormField(
            controller: _assignedToController,
            label: 'Responsable (opcional)',
            hint: 'Nombre del responsable',
            icon: Icons.person_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return _buildSection(
      title: 'Configuración',
      icon: Icons.settings_rounded,
      child: Column(
        children: [
          // Prioridad y Estado en fila responsive
          LayoutBuilder(
            builder: (context, constraints) {
              // Si el ancho es muy pequeño, mostrar en columna
              if (constraints.maxWidth < 300) {
                return Column(
                  children: [
                    _buildDropdownField<String>(
                      value: _selectedPriority,
                      label: 'Prioridad',
                      icon: _getPriorityIcon(_selectedPriority),
                      items: _priorities,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        }
                      },
                      itemBuilder:
                          (priority) => Row(
                            children: [
                              Icon(
                                _getPriorityIcon(priority),
                                color: _getPriorityColor(priority),
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  priority,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField<String>(
                      value: _selectedStatus,
                      label: 'Estado Inicial',
                      icon: Icons.flag_rounded,
                      items: _statuses,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField<String>(
                        value: _selectedPriority,
                        label: 'Prioridad',
                        icon: _getPriorityIcon(_selectedPriority),
                        items: _priorities,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          }
                        },
                        itemBuilder:
                            (priority) => Row(
                              children: [
                                Icon(
                                  _getPriorityIcon(priority),
                                  color: _getPriorityColor(priority),
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    priority,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdownField<String>(
                        value: _selectedStatus,
                        label: 'Estado Inicial',
                        icon: Icons.flag_rounded,
                        items: _statuses,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Fecha programada
          _buildDateSelector(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
            icon != null
                ? Icon(icon, color: AppColors.primaryGreen, size: 20)
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: AppColors.softBackground,
        counterStyle: const TextStyle(color: AppColors.greyText, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T value,
    required String label,
    required IconData icon,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    Widget Function(T)? itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        filled: true,
        fillColor: AppColors.softBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      items:
          items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child:
                  itemBuilder?.call(item) ??
                  Text(item.toString(), overflow: TextOverflow.ellipsis),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildZoneSelector() {
    return InkWell(
      onTap: _selectZone,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreen),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.softBackground,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zona de cultivo',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedZoneName ?? 'Seleccionar zona',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _selectedZoneName != null
                              ? AppColors.darkGreen
                              : AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.greyText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreen),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.softBackground,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fecha programada',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.greyText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.save_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  _isLoading ? 'Creando...' : 'Crear Tarea',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.greyText,
              side: const BorderSide(color: AppColors.lightGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
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
            'Creando tarea...',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para iconos y colores
  IconData _getTaskTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'siembra':
        return Icons.eco_rounded;
      case 'riego':
        return Icons.water_drop_rounded;
      case 'poda':
        return Icons.content_cut_rounded;
      case 'limpieza':
        return Icons.cleaning_services_rounded;
      case 'cosecha':
        return Icons.agriculture_rounded;
      case 'fertilización':
        return Icons.science_rounded;
      case 'control de plagas':
        return Icons.bug_report_rounded;
      case 'mantenimiento':
        return Icons.build_rounded;
      default:
        return Icons.task_rounded;
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

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'baja':
        return Icons.keyboard_arrow_down_rounded;
      case 'media':
        return Icons.remove_rounded;
      case 'alta':
        return Icons.keyboard_arrow_up_rounded;
      case 'urgente':
        return Icons.priority_high_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'baja':
        return Colors.green;
      case 'media':
        return Colors.orange;
      case 'alta':
        return Colors.red;
      case 'urgente':
        return Colors.deepOrange;
      default:
        return AppColors.primaryGreen;
    }
  }

  // Métodos de interacción
  void _selectZone() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Seleccionar Zona',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    {'id': 'zone_1', 'name': 'Zona Norte'},
                    {'id': 'zone_2', 'name': 'Zona Sur'},
                    {'id': 'zone_3', 'name': 'Zona Este'},
                    {'id': 'zone_4', 'name': 'Zona Oeste'},
                  ].map(
                    (zone) => ListTile(
                      leading: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primaryGreen,
                      ),
                      title: Text(zone['name']!),
                      onTap: () {
                        setState(() {
                          _selectedZoneId = zone['id'];
                          _selectedZoneName = zone['name'];
                        });
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryGreen),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedZoneId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una zona de cultivo'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear la nueva tarea - dejar el ID vacío para que Firebase genere uno automáticamente
      final newTask = Task(
        id: '', // Firebase generará el ID automáticamente
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? ''
                : _descriptionController.text.trim(),
        type: _selectedType,
        status: _selectedStatus,
        priority: _selectedPriority,
        zoneId: _selectedZoneId!,
        zoneName: _selectedZoneName!,
        assignedTo:
            _assignedToController.text.trim().isEmpty
                ? ''
                : _assignedToController.text.trim(),
        createdAt: DateTime.now(),
        scheduledDate: _selectedDate,
      );

      // Guardar la tarea usando el servicio
      await taskService.createTask(newTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea creada exitosamente'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(
          context,
          true,
        ); // Devolver true para indicar que se creó una tarea
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la tarea: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
