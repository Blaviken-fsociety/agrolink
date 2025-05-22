import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_log.dart';

class LogService {
  final CollectionReference logsRef = FirebaseFirestore.instance.collection('logs');

  Future<void> addLog(ActivityLog log) async {
    await logsRef.add(log.toMap());
  }

  Stream<List<ActivityLog>> getLogsForUser(String userId) {
    return logsRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityLog.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}