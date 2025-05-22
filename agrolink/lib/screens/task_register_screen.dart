import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class TaskRegisterScreen extends StatefulWidget {
  final String zoneId;

  const TaskRegisterScreen({super.key, required this.zoneId});

  @override
  State<TaskRegisterScreen> createState() => _TaskRegisterScreenState();
}

class _TaskRegisterScreenState extends State<TaskRegisterScreen> {
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final assignedToCtrl = TextEditingController();
  DateTime? selectedDate;
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(label: 'Título', controller: titleCtrl),
            CustomInput(label: 'Descripción', controller: descriptionCtrl),
            CustomInput(label: 'Responsable (user ID)', controller: assignedToCtrl),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(selectedDate == null
                  ? 'Seleccionar fecha'
                  : 'Fecha: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Guardar tarea',
              onPressed: () async {
                if (selectedDate == null) return;
                final task = Task(
                  id: '',
                  zoneId: widget.zoneId,
                  title: titleCtrl.text.trim(),
                  description: descriptionCtrl.text.trim(),
                  dueDate: selectedDate!,
                  assignedTo: assignedToCtrl.text.trim(),
                );
                await taskService.addTask(task);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}