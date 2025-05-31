import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/statistics.dart';

class StatisticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Statistics> getStatistics() async {
    try {
      // Get all user participations
      final participationsSnapshot = await _firestore
          .collection('user_participations')
          .get();

      // Get all zones
      final zonesSnapshot = await _firestore
          .collection('zones')
          .get();

      // Calculate statistics
      int totalHours = 0;
      int activeVolunteers = 0;
      int totalParticipations = 0;
      int currentMonthHours = 0;
      int previousMonthHours = 0;
      Map<String, int> participationByActivity = {};
      
      for (final doc in participationsSnapshot.docs) {
        final data = doc.data();
        totalHours += (data['totalHours'] ?? 0) as int;
        totalParticipations += (data['totalActivities'] ?? 0) as int;
        currentMonthHours += (data['currentMonthHours'] ?? 0) as int;
        
        // Count as active if has activities this month
        if ((data['currentMonthHours'] ?? 0) > 0) {
          activeVolunteers++;
        }
        
        // Count participation by activity type
        final recentActivities = data['recentActivities'] as List<dynamic>? ?? [];
        for (final activity in recentActivities) {
          if (activity is Map<String, dynamic>) {
            final type = activity['type'] as String? ?? 'otros';
            participationByActivity[type] = (participationByActivity[type] ?? 0) + 1;
          }
        }
      }

      // Calculate zone statistics
      Map<String, Map<String, dynamic>> zoneStats = {};
      double totalArea = 0.0;
      
      for (final doc in zonesSnapshot.docs) {
        final data = doc.data();
        final zoneName = data['name'] ?? doc.id;
        final area = (data['area'] ?? 0.0).toDouble();
        totalArea += area;
        
        // Count participants in this zone
        int participants = 0;
        for (final participationDoc in participationsSnapshot.docs) {
          final participationData = participationDoc.data();
          final recentActivities = participationData['recentActivities'] as List<dynamic>? ?? [];
          
          bool hasActivityInZone = recentActivities.any((activity) {
            if (activity is Map<String, dynamic>) {
              return activity['zone'] == zoneName;
            }
            return false;
          });
          
          if (hasActivityInZone) {
            participants++;
          }
        }
        
        zoneStats[zoneName] = {
          'cropType': data['cropType'] ?? 'Sin especificar',
          'area': area,
          'participants': participants,
        };
      }

      // Calculate previous month hours (simplified - in real app, you'd track historical data)
      previousMonthHours = (currentMonthHours * 0.8).round(); // Mock calculation

      return Statistics(
        totalHours: totalHours,
        activeVolunteers: activeVolunteers,
        totalZones: zonesSnapshot.docs.length,
        totalArea: totalArea,
        totalParticipations: totalParticipations,
        participationByActivity: participationByActivity,
        zoneStats: zoneStats,
        currentMonthHours: currentMonthHours,
        previousMonthHours: previousMonthHours,
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  Stream<Statistics> getStatisticsStream() {
    return Stream.periodic(const Duration(minutes: 5))
        .asyncMap((_) => getStatistics())
        .handleError((error) {
      throw Exception('Error en el stream de estadísticas: $error');
    });
  }

  Future<Map<String, dynamic>> getMonthlyTrends() async {
    try {
      // In a real implementation, you'd have historical data
      // For now, return mock trend data
      return {
        'currentMonth': currentMonthHours,
        'previousMonth': previousMonthHours,
        'growth': ((currentMonthHours - previousMonthHours) / 
                  (previousMonthHours > 0 ? previousMonthHours : 1) * 100),
        'weeklyData': [
          {'week': 1, 'hours': 45},
          {'week': 2, 'hours': 52},
          {'week': 3, 'hours': 38},
          {'week': 4, 'hours': 61},
        ],
      };
    } catch (e) {
      throw Exception('Error al obtener tendencias mensuales: $e');
    }
  }

  // Helper variables for calculations
  int currentMonthHours = 0;
  int previousMonthHours = 0;
}