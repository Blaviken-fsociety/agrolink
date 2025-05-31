import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/zone.dart';

class ZoneService {
  final CollectionReference zonesRef = FirebaseFirestore.instance.collection(
    'zones',
  );

  Future<void> addZone(Zone zone) async {
    try {
      await zonesRef.add(zone.toMap());
      print('Zona agregada exitosamente: ${zone.name}');
    } catch (e) {
      print('Error al agregar zona: $e');
      rethrow;
    }
  }

  Stream<List<Zone>> getZones() {
    return zonesRef
        .snapshots()
        .map((snapshot) {
          List<Zone> zones = [];

          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();

              // Verificar que data no sea null
              if (data == null) {
                print('Documento con data null: ${doc.id}');
                continue;
              }

              final dataMap = data as Map<String, dynamic>;

              // Verificar que tenga los campos básicos
              if (!_hasRequiredFields(dataMap)) {
                print('Documento con campos faltantes: ${doc.id}');
                print('Datos: $dataMap');
                continue;
              }

              final zone = Zone.fromMap(doc.id, dataMap);

              // Verificar que la zona sea válida
              if (zone.isValid()) {
                zones.add(zone);
              } else {
                print('Zona inválida creada: $zone');
              }
            } catch (e) {
              print('Error al procesar documento ${doc.id}: $e');
              // Continúa con el siguiente documento en lugar de fallar todo
              continue;
            }
          }

          print('Zonas cargadas exitosamente: ${zones.length}');
          return zones;
        })
        .handleError((error) {
          print('Error en el stream de zonas: $error');
          // Re-lanza el error para que la UI pueda manejarlo
          throw error;
        });
  }

  // Verificar que el documento tenga los campos requeridos
  bool _hasRequiredFields(Map<String, dynamic> data) {
    return data.containsKey('name') &&
        data.containsKey('size') &&
        data.containsKey('cropType') &&
        data.containsKey('status');
  }

  // Método para obtener una zona específica por ID
  Future<Zone?> getZoneById(String id) async {
    try {
      final doc = await zonesRef.doc(id).get();

      if (!doc.exists) {
        print('Zona con ID $id no existe');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        print('Zona con ID $id tiene data null');
        return null;
      }

      return Zone.fromMap(doc.id, data);
    } catch (e) {
      print('Error al obtener zona por ID $id: $e');
      return null;
    }
  }

  // Método para verificar la conectividad con Firebase
  Future<bool> testConnection() async {
    try {
      await zonesRef.limit(1).get();
      return true;
    } catch (e) {
      print('Error de conexión con Firebase: $e');
      return false;
    }
  }
}
