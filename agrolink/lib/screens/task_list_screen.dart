import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/task_service.dart';
import '../services/log_service.dart';
import '../models/task.dart';
import '../models/activity_log.dart';

class TaskListScreen extends StatelessWidget {
  final String zoneId;

  const TaskListScreen({super.key, required this.zoneId});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();
    final logService = LogService();

    return Scaffold(
      appBar: AppBar(title: const Text('Tareas de la zona')),
      body: StreamBuilder<List<Task>>(
        stream: taskService.getTasksForZone(zoneId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error');
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return CheckboxListTile(
                title: Text(task.title),
                subtitle: Text('Responsable: ${task.assignedTo}\nVence: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
                value: task.completed,
                onChanged: (val) async {
                  await taskService.toggleComplete(task.id, val ?? false);

                  if (val == true) {
                    final log = ActivityLog(
                      id: '',
                      userId: task.assignedTo,
                      taskId: task.id,
                      zoneId: task.zoneId,
                      title: task.title,
                      description: task.description,
                      timestamp: DateTime.now(),
                    );
                    await logService.addLog(log);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}