import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/zone.dart';

class ZoneService {
  final CollectionReference zonesRef =
      FirebaseFirestore.instance.collection('zones');

  Future<void> addZone(Zone zone) async {
    await zonesRef.add(zone.toMap());
  }

  Stream<List<Zone>> getZones() {
    return zonesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Zone.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}