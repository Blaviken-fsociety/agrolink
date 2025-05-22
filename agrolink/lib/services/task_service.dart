import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    await tasksRef.add(task.toMap());
  }

  Stream<List<Task>> getTasksForZone(String zoneId) {
    return tasksRef
        .where('zoneId', isEqualTo: zoneId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> toggleComplete(String taskId, bool newValue) async {
    await tasksRef.doc(taskId).update({'completed': newValue});
  }
}