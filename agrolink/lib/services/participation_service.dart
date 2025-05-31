import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_participation.dart';

class ParticipationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user participation as Future (for FutureBuilder)
  Future<UserParticipation> getUserParticipation(String userId) async {
    final doc =
        await _firestore.collection('user_participations').doc(userId).get();

    if (doc.exists) {
      return UserParticipation.fromMap(doc.data()!, userId);
    } else {
      // Create default participation if doesn't exist
      await createUserParticipation(userId);
      return UserParticipation(
        userId: userId,
        totalHours: 0,
        totalActivities: 0,
        currentMonthHours: 0,
        activeZones: 0,
        level: 'Principiante',
        recentActivities: [],
        achievements: [],
      );
    }
  }

  // Get user participation as Stream (for StreamBuilder)
  Stream<UserParticipation?> getUserParticipationStream(String userId) {
    return _firestore
        .collection('user_participations')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return UserParticipation.fromMap(doc.data()!, userId);
          }
          return null;
        });
  }

  Future<UserParticipation?> getUserParticipationOnce(String userId) async {
    final doc =
        await _firestore.collection('user_participations').doc(userId).get();

    if (doc.exists) {
      return UserParticipation.fromMap(doc.data()!, userId);
    }
    return null;
  }

  // Get all activities for a user
  Future<List<Map<String, dynamic>>> getUserActivities(String userId) async {
    try {
      // Get from activities collection where userId matches
      final activitiesSnapshot =
          await _firestore
              .collection('activities')
              .where('userId', isEqualTo: userId)
              .orderBy('date', descending: true)
              .get();

      List<Map<String, dynamic>> activities = [];

      for (final doc in activitiesSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'type': data['type'] ?? 'otros',
          'zone': data['zone'] ?? '',
          'hours': data['hours'] ?? 0,
          'date': data['date'] ?? DateTime.now().toIso8601String(),
        });
      }

      // If no activities in activities collection, get from user participation recent activities
      if (activities.isEmpty) {
        final userParticipation = await getUserParticipationOnce(userId);
        if (userParticipation != null) {
          activities = userParticipation.recentActivities;
        }
      }

      return activities;
    } catch (e) {
      throw Exception('Error al obtener actividades del usuario: $e');
    }
  }

  // Get user activity log
  // Get user activity log - Modified to avoid composite index
  Future<List<Map<String, dynamic>>> getUserLog(String userId) async {
    try {
      // Simple query without orderBy to avoid composite index requirement
      final logsSnapshot =
          await _firestore
              .collection('user_logs')
              .where('userId', isEqualTo: userId)
              .get();

      List<Map<String, dynamic>> logs = [];

      for (final doc in logsSnapshot.docs) {
        final data = doc.data();
        logs.add({
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
          'type': data['type'] ?? 'info',
        });
      }

      // Sort by timestamp in descending order (most recent first)
      logs.sort((a, b) {
        final dateA = DateTime.parse(a['timestamp']);
        final dateB = DateTime.parse(b['timestamp']);
        return dateB.compareTo(dateA);
      });

      // Limit to 50 most recent
      if (logs.length > 50) {
        logs = logs.take(50).toList();
      }

      // If no logs exist, create some sample logs based on recent activities
      if (logs.isEmpty) {
        final userParticipation = await getUserParticipationOnce(userId);
        if (userParticipation != null) {
          for (final activity in userParticipation.recentActivities.take(10)) {
            logs.add({
              'title': 'Actividad completada: ${activity['title']}',
              'description':
                  'Has completado ${activity['hours']} horas de ${activity['type']} en ${activity['zone']}',
              'timestamp': activity['date'] ?? DateTime.now().toIso8601String(),
              'type': 'activity',
            });
          }

          // Sort the generated logs as well
          logs.sort((a, b) {
            final dateA = DateTime.parse(a['timestamp']);
            final dateB = DateTime.parse(b['timestamp']);
            return dateB.compareTo(dateA);
          });
        }
      }

      return logs;
    } catch (e) {
      throw Exception('Error al obtener bitácora del usuario: $e');
    }
  }

  Future<void> createUserParticipation(String userId) async {
    await _firestore.collection('user_participations').doc(userId).set({
      'totalHours': 0,
      'totalActivities': 0,
      'currentMonthHours': 0,
      'activeZones': 0,
      'level': 'Principiante',
      'recentActivities': [],
      'achievements': [],
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> addActivity(String userId, Map<String, dynamic> activity) async {
    final userRef = _firestore.collection('user_participations').doc(userId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);

      if (!doc.exists) {
        transaction.set(userRef, {
          'totalHours': activity['hours'] ?? 0,
          'totalActivities': 1,
          'currentMonthHours': activity['hours'] ?? 0,
          'activeZones': 1,
          'level': 'Principiante',
          'recentActivities': [activity],
          'achievements': [],
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        final data = doc.data()!;
        final currentHours = data['totalHours'] ?? 0;
        final currentActivities = data['totalActivities'] ?? 0;
        final currentMonthHours = data['currentMonthHours'] ?? 0;
        final recentActivities = List<Map<String, dynamic>>.from(
          data['recentActivities'] ?? [],
        );

        // Agregar nueva actividad al inicio de la lista
        recentActivities.insert(0, activity);

        // Mantener solo las últimas 10 actividades
        if (recentActivities.length > 10) {
          recentActivities.removeRange(10, recentActivities.length);
        }

        // Calcular nuevo nivel basado en horas totales
        final newTotalHours = currentHours + (activity['hours'] ?? 0);
        String newLevel = _calculateLevel(newTotalHours);

        transaction.update(userRef, {
          'totalHours': newTotalHours,
          'totalActivities': currentActivities + 1,
          'currentMonthHours': currentMonthHours + (activity['hours'] ?? 0),
          'level': newLevel,
          'recentActivities': recentActivities,
          'lastActivityAt': DateTime.now().toIso8601String(),
        });
      }
    });

    // Also save to activities collection for detailed tracking
    await _firestore.collection('activities').add({
      'userId': userId,
      'title': activity['title'],
      'description': activity['description'],
      'type': activity['type'],
      'zone': activity['zone'],
      'hours': activity['hours'],
      'date': activity['date'] ?? DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Add log entry
    await _firestore.collection('user_logs').add({
      'userId': userId,
      'title': 'Nueva actividad registrada',
      'description':
          'Has completado ${activity['hours']} horas de ${activity['type']} en ${activity['zone']}',
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'activity',
    });
  }

  Future<void> addAchievement(
    String userId,
    Map<String, dynamic> achievement,
  ) async {
    await _firestore.collection('user_participations').doc(userId).update({
      'achievements': FieldValue.arrayUnion([achievement]),
    });

    // Add log entry for achievement
    await _firestore.collection('user_logs').add({
      'userId': userId,
      'title': '¡Nuevo logro desbloqueado!',
      'description': 'Has obtenido el logro: ${achievement['title']}',
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'achievement',
    });
  }

  Future<void> updateActiveZones(String userId, int zones) async {
    await _firestore.collection('user_participations').doc(userId).update({
      'activeZones': zones,
    });
  }

  Future<void> resetMonthlyHours(String userId) async {
    await _firestore.collection('user_participations').doc(userId).update({
      'currentMonthHours': 0,
    });
  }

  Stream<List<UserParticipation>> getTopVolunteers({int limit = 10}) {
    return _firestore
        .collection('user_participations')
        .orderBy('totalHours', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => UserParticipation.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  String _calculateLevel(int totalHours) {
    if (totalHours >= 200) return 'Experto';
    if (totalHours >= 100) return 'Avanzado';
    if (totalHours >= 50) return 'Intermedio';
    return 'Principiante';
  }
}
