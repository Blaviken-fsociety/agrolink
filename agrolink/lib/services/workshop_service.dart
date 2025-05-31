import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workshop.dart';

class WorkshopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Workshop>> getWorkshops() {
    return _firestore
        .collection('workshops')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Workshop.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addWorkshop(Workshop workshop) async {
    await _firestore.collection('workshops').add(workshop.toMap());
  }

  Future<void> joinWorkshop(String workshopId, String userId) async {
    await _firestore.collection('workshops').doc(workshopId).update({
      'participants': FieldValue.increment(1),
    });

    await _firestore.collection('workshop_participants').add({
      'workshopId': workshopId,
      'userId': userId,
      'joinedAt': DateTime.now().toIso8601String(),
    });
  }
}