import 'package:cloud_firestore/cloud_firestore.dart';

class TaskAssignment {
  final String userId;
  final String userName;
  final double estimatedHours;
  final DateTime assignedAt;
  final double? actualHours;
  final DateTime? completedAt;

  TaskAssignment({
    required this.userId,
    required this.userName,
    required this.estimatedHours,
    required this.assignedAt,
    this.actualHours,
    this.completedAt,
  });

  factory TaskAssignment.fromMap(Map<String, dynamic> data) {
    return TaskAssignment(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      estimatedHours: (data['estimatedHours'] ?? 0.0).toDouble(),
      assignedAt: data['assignedAt'] is Timestamp 
          ? (data['assignedAt'] as Timestamp).toDate()
          : DateTime.parse(data['assignedAt'] ?? DateTime.now().toIso8601String()),
      actualHours: data['actualHours']?.toDouble(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] is Timestamp
              ? (data['completedAt'] as Timestamp).toDate()
              : DateTime.parse(data['completedAt']))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'estimatedHours': estimatedHours,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'actualHours': actualHours,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String priority;
  final String zoneId;
  final String zoneName;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime scheduledDate;
  final DateTime? completedAt;
  final List<TaskAssignment> assignments;
  final double? estimatedTotalHours;
  final int maxAssignees;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.priority,
    required this.zoneId,
    required this.zoneName,
    required this.assignedTo,
    required this.createdAt,
    required this.scheduledDate,
    this.completedAt,
    this.assignments = const [],
    this.estimatedTotalHours,
    this.maxAssignees = 1,
  });

  // Crear Task desde Firestore DocumentSnapshot
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Procesar assignments
    List<TaskAssignment> assignments = [];
    if (data['assignments'] != null) {
      final assignmentsData = data['assignments'] as List<dynamic>;
      assignments = assignmentsData
          .map((assignmentData) => TaskAssignment.fromMap(assignmentData as Map<String, dynamic>))
          .toList();
    }
    
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? 'Pendiente',
      priority: data['priority'] ?? 'Media',
      zoneId: data['zoneId'] ?? '',
      zoneName: data['zoneName'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scheduledDate: (data['scheduledDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      assignments: assignments,
      estimatedTotalHours: data['estimatedTotalHours']?.toDouble(),
      maxAssignees: data['maxAssignees'] ?? 1,
    );
  }

  // Crear Task desde Map (útil para crear desde JSON)
  factory Task.fromMap(Map<String, dynamic> data, String id) {
    // Procesar assignments
    List<TaskAssignment> assignments = [];
    if (data['assignments'] != null) {
      final assignmentsData = data['assignments'] as List<dynamic>;
      assignments = assignmentsData
          .map((assignmentData) => TaskAssignment.fromMap(assignmentData as Map<String, dynamic>))
          .toList();
    }

    return Task(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      status: data['status'] ?? 'Pendiente',
      priority: data['priority'] ?? 'Media',
      zoneId: data['zoneId'] ?? '',
      zoneName: data['zoneName'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      createdAt: data['createdAt'] is Timestamp 
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      scheduledDate: data['scheduledDate'] is Timestamp
          ? (data['scheduledDate'] as Timestamp).toDate()
          : DateTime.parse(data['scheduledDate'] ?? DateTime.now().toIso8601String()),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] is Timestamp
              ? (data['completedAt'] as Timestamp).toDate()
              : DateTime.parse(data['completedAt']))
          : null,
      assignments: assignments,
      estimatedTotalHours: data['estimatedTotalHours']?.toDouble(),
      maxAssignees: data['maxAssignees'] ?? 1,
    );
  }

  // Convertir Task a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'priority': priority,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'assignedTo': assignedTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'assignments': assignments.map((assignment) => assignment.toMap()).toList(),
      'estimatedTotalHours': estimatedTotalHours,
      'maxAssignees': maxAssignees,
    };
  }

  // Método copyWith para crear copias modificadas
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? status,
    String? priority,
    String? zoneId,
    String? zoneName,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? scheduledDate,
    DateTime? completedAt,
    List<TaskAssignment>? assignments,
    double? estimatedTotalHours,
    int? maxAssignees,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      assignments: assignments ?? this.assignments,
      estimatedTotalHours: estimatedTotalHours ?? this.estimatedTotalHours,
      maxAssignees: maxAssignees ?? this.maxAssignees,
    );
  }

  // Validaciones
  bool get isValid {
    return title.isNotEmpty &&
           type.isNotEmpty &&
           status.isNotEmpty &&
           priority.isNotEmpty &&
           zoneId.isNotEmpty &&
           zoneName.isNotEmpty;
  }

  // Estados de la tarea
  bool get isPending => status.toLowerCase() == 'pendiente';
  bool get isInProgress => status.toLowerCase() == 'en progreso';
  bool get isCompleted => status.toLowerCase() == 'completada';

  // Verificaciones de fecha
  bool get isOverdue {
    if (isCompleted) return false;
    return scheduledDate.isBefore(DateTime.now()) && 
           !_isSameDay(scheduledDate, DateTime.now());
  }

  bool get isDueToday {
    return _isSameDay(scheduledDate, DateTime.now());
  }

  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _isSameDay(scheduledDate, tomorrow);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return scheduledDate.isAfter(now) && scheduledDate.isBefore(nextWeek);
  }

  // Prioridades
  bool get isHighPriority => priority.toLowerCase() == 'alta' || priority.toLowerCase() == 'urgente';
  bool get isUrgent => priority.toLowerCase() == 'urgente';

  // Métodos relacionados con assignments
  bool get hasAvailableSpots => assignments.length < maxAssignees;
  int get availableSpots => maxAssignees - assignments.length;
  double get totalEstimatedHours => assignments.fold(0.0, (sum, assignment) => sum + assignment.estimatedHours);
  bool isUserAssigned(String userId) => assignments.any((assignment) => assignment.userId == userId);

  // Método auxiliar para comparar fechas
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Tiempo restante hasta la fecha programada
  Duration get timeUntilDue {
    return scheduledDate.difference(DateTime.now());
  }

  // Descripción del tiempo restante
  String get timeUntilDueDescription {
    final duration = timeUntilDue;
    
    if (isOverdue) {
      final overdueDuration = DateTime.now().difference(scheduledDate);
      if (overdueDuration.inDays > 0) {
        return 'Vencida hace ${overdueDuration.inDays} día${overdueDuration.inDays > 1 ? 's' : ''}';
      } else if (overdueDuration.inHours > 0) {
        return 'Vencida hace ${overdueDuration.inHours} hora${overdueDuration.inHours > 1 ? 's' : ''}';
      } else {
        return 'Vencida hace ${overdueDuration.inMinutes} minuto${overdueDuration.inMinutes > 1 ? 's' : ''}';
      }
    }
    
    if (isDueToday) {
      return 'Vence hoy';
    }
    
    if (isDueTomorrow) {
      return 'Vence mañana';
    }
    
    if (duration.inDays > 0) {
      return 'En ${duration.inDays} día${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return 'En ${duration.inHours} hora${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return 'En ${duration.inMinutes} minuto${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora';
    }
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, type: $type, status: $status, priority: $priority, scheduledDate: $scheduledDate, assignments: ${assignments.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}