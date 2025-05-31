import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  // Instancia de Firestore
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Referencia a la colección de tareas
  static const String _collectionName = 'tasks';
  static CollectionReference get _tasksCollection => 
      _firestore.collection(_collectionName);

  // Stream para obtener tareas disponibles para inscripción (pendientes y en progreso)
  Stream<List<Task>> getAvailableTasks() {
    return _tasksCollection
        .where('status', whereIn: ['Pendiente', 'En progreso'])
        .orderBy('scheduledDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .where((task) => task.hasAvailableSpots)
            .toList());
  }

  // Stream para obtener tareas donde el usuario está inscrito
  Stream<List<Task>> getUserAssignedTasks(String userId) {
    return _tasksCollection
        .where('assignments', arrayContains: {
          'userId': userId,
        })
        .orderBy('scheduledDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Inscribir usuario en una tarea
  Future<void> assignUserToTask({
    required String taskId,
    required String userId,
    required String userName,
    required double estimatedHours,
  }) async {
    try {
      final taskRef = _tasksCollection.doc(taskId);
      
      await _firestore.runTransaction((transaction) async {
        final taskDoc = await transaction.get(taskRef);
        
        if (!taskDoc.exists) {
          throw Exception('La tarea no existe');
        }
        
        final task = Task.fromFirestore(taskDoc);
        
        // Verificar si ya está inscrito
        if (task.isUserAssigned(userId)) {
          throw Exception('Ya estás inscrito en esta tarea');
        }
        
        // Verificar disponibilidad
        if (!task.hasAvailableSpots) {
          throw Exception('No hay cupos disponibles para esta tarea');
        }
        
        // Crear nueva asignación
        final newAssignment = TaskAssignment(
          userId: userId,
          userName: userName,
          estimatedHours: estimatedHours,
          assignedAt: DateTime.now(),
        );
        
        // Agregar la nueva asignación
        final updatedAssignments = [...task.assignments, newAssignment];
        
        // Actualizar la tarea
        transaction.update(taskRef, {
          'assignments': updatedAssignments.map((a) => a.toMap()).toList(),
        });
      });
    } catch (e) {
      throw Exception('Error al inscribirse en la tarea: $e');
    }
  }

  // Remover usuario de una tarea
  Future<void> removeUserFromTask({
    required String taskId,
    required String userId,
  }) async {
    try {
      final taskRef = _tasksCollection.doc(taskId);
      
      await _firestore.runTransaction((transaction) async {
        final taskDoc = await transaction.get(taskRef);
        
        if (!taskDoc.exists) {
          throw Exception('La tarea no existe');
        }
        
        final task = Task.fromFirestore(taskDoc);
        
        // Verificar si está inscrito
        if (!task.isUserAssigned(userId)) {
          throw Exception('No estás inscrito en esta tarea');
        }
        
        // Remover la asignación
        final updatedAssignments = task.assignments
            .where((assignment) => assignment.userId != userId)
            .toList();
        
        // Actualizar la tarea
        transaction.update(taskRef, {
          'assignments': updatedAssignments.map((a) => a.toMap()).toList(),
        });
      });
    } catch (e) {
      throw Exception('Error al retirarse de la tarea: $e');
    }
  }

  // Actualizar horas trabajadas en una tarea
  Future<void> updateWorkingHours({
    required String taskId,
    required String userId,
    required double actualHours,
    bool markAsCompleted = false,
  }) async {
    try {
      final taskRef = _tasksCollection.doc(taskId);
      
      await _firestore.runTransaction((transaction) async {
        final taskDoc = await transaction.get(taskRef);
        
        if (!taskDoc.exists) {
          throw Exception('La tarea no existe');
        }
        
        final task = Task.fromFirestore(taskDoc);
        
        // Encontrar y actualizar la asignación del usuario
        final updatedAssignments = task.assignments.map((assignment) {
          if (assignment.userId == userId) {
            return TaskAssignment(
              userId: assignment.userId,
              userName: assignment.userName,
              estimatedHours: assignment.estimatedHours,
              assignedAt: assignment.assignedAt,
              actualHours: actualHours,
              completedAt: markAsCompleted ? DateTime.now() : assignment.completedAt,
            );
          }
          return assignment;
        }).toList();
        
        // Actualizar la tarea
        transaction.update(taskRef, {
          'assignments': updatedAssignments.map((a) => a.toMap()).toList(),
        });
      });
    } catch (e) {
      throw Exception('Error al actualizar horas trabajadas: $e');
    }
  }

  // Stream para obtener todas las tareas en tiempo real
  Stream<List<Task>> getAllTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas por zona en tiempo real
  Stream<List<Task>> getTasksByZone(String zoneId) {
    return _tasksCollection
        .where('zoneId', isEqualTo: zoneId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas por estado
  Stream<List<Task>> getTasksByStatus(String status) {
    return _tasksCollection
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas por prioridad
  Stream<List<Task>> getTasksByPriority(String priority) {
    return _tasksCollection
        .where('priority', isEqualTo: priority)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas vencidas
  Stream<List<Task>> getOverdueTasks() {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    
    return _tasksCollection
        .where('scheduledDate', isLessThan: Timestamp.fromDate(startOfToday))
        .where('status', whereNotIn: ['Completada', 'completada'])
        .orderBy('scheduledDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas de hoy
  Stream<List<Task>> getTodayTasks() {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));
    
    return _tasksCollection
        .where('scheduledDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .where('scheduledDate', isLessThan: Timestamp.fromDate(endOfToday))
        .orderBy('scheduledDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Stream para obtener tareas próximas (próximos N días)
  Stream<List<Task>> getUpcomingTasks({int days = 7}) {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: days));
    
    return _tasksCollection
        .where('scheduledDate', isGreaterThan: Timestamp.fromDate(now))
        .where('scheduledDate', isLessThanOrEqualTo: Timestamp.fromDate(futureDate))
        .orderBy('scheduledDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList());
  }

  // Crear nueva tarea
  Future<void> createTask(Task task) async {
    try {
      // Validar que la tarea sea válida
      if (!task.isValid) {
        throw Exception('Datos de tarea inválidos');
      }

      // Si no se proporciona un ID, Firestore generará uno automáticamente
      final taskData = task.toFirestore();
      
      if (task.id.isNotEmpty) {
        // Si se proporciona un ID específico, usarlo
        await _tasksCollection.doc(task.id).set(taskData);
      } else {
        // Dejar que Firestore genere el ID automáticamente
        await _tasksCollection.add(taskData);
      }
    } catch (e) {
      throw Exception('Error al crear la tarea: $e');
    }
  }

  // Actualizar tarea existente
  Future<void> updateTask(Task updatedTask) async {
    try {
      if (updatedTask.id.isEmpty) {
        throw Exception('ID de tarea requerido para actualizar');
      }

      await _tasksCollection
          .doc(updatedTask.id)
          .update(updatedTask.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar la tarea: $e');
    }
  }

  // Actualizar solo el estado de una tarea
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      if (taskId.isEmpty) {
        throw Exception('ID de tarea requerido');
      }

      final updateData = <String, dynamic>{
        'status': newStatus,
      };

      // Si el estado es completada, agregar fecha de completado
      if (newStatus.toLowerCase() == 'completada') {
        updateData['completedAt'] = Timestamp.fromDate(DateTime.now());
      } else {
        updateData['completedAt'] = null;
      }

      await _tasksCollection.doc(taskId).update(updateData);
    } catch (e) {
      throw Exception('Error al actualizar el estado de la tarea: $e');
    }
  }

  // Eliminar tarea
  Future<void> deleteTask(String taskId) async {
    try {
      if (taskId.isEmpty) {
        throw Exception('ID de tarea requerido');
      }

      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Error al eliminar la tarea: $e');
    }
  }

  // Obtener tarea por ID (método único, no stream)
  Future<Task?> getTaskById(String taskId) async {
    try {
      if (taskId.isEmpty) return null;

      final doc = await _tasksCollection.doc(taskId).get();
      
      if (doc.exists) {
        return Task.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener la tarea: $e');
    }
  }

  // Obtener estadísticas de tareas
  Future<TaskStatistics> getTaskStatistics() async {
    try {
      final snapshot = await _tasksCollection.get();
      final tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();

      final total = tasks.length;
      final pending = tasks.where((t) => t.isPending).length;
      final inProgress = tasks.where((t) => t.isInProgress).length;
      final completed = tasks.where((t) => t.isCompleted).length;
      final overdue = tasks.where((t) => t.isOverdue).length;

      return TaskStatistics(
        total: total,
        pending: pending,
        inProgress: inProgress,
        completed: completed,
        overdue: overdue,
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  // Stream para estadísticas en tiempo real
  Stream<TaskStatistics> getTaskStatisticsStream() {
    return getAllTasks().map((tasks) {
      final total = tasks.length;
      final pending = tasks.where((t) => t.isPending).length;
      final inProgress = tasks.where((t) => t.isInProgress).length;
      final completed = tasks.where((t) => t.isCompleted).length;
      final overdue = tasks.where((t) => t.isOverdue).length;

      return TaskStatistics(
        total: total,
        pending: pending,
        inProgress: inProgress,
        completed: completed,
        overdue: overdue,
      );
    });
  }
}

// Clase para estadísticas de tareas
class TaskStatistics {
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;

  TaskStatistics({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.overdue,
  });

  double get completionRate => total > 0 ? (completed / total) * 100 : 0;
  double get overdueRate => total > 0 ? (overdue / total) * 100 : 0;
  int get activeTasks => pending + inProgress;

  @override
  String toString() {
    return 'TaskStatistics(total: $total, pending: $pending, inProgress: $inProgress, completed: $completed, overdue: $overdue)';
  }
}