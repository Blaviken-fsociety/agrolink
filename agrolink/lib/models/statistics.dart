class Statistics {
  final int totalHours;
  final int activeVolunteers;
  final int totalZones;
  final double totalArea;
  final int totalParticipations;
  final Map<String, int> participationByActivity;
  final Map<String, Map<String, dynamic>> zoneStats;
  final int currentMonthHours;
  final int previousMonthHours;

  Statistics({
    required this.totalHours,
    required this.activeVolunteers,
    required this.totalZones,
    required this.totalArea,
    required this.totalParticipations,
    required this.participationByActivity,
    required this.zoneStats,
    required this.currentMonthHours,
    required this.previousMonthHours,
  });

  factory Statistics.fromMap(Map<String, dynamic> map) {
    return Statistics(
      totalHours: map['totalHours'] ?? 0,
      activeVolunteers: map['activeVolunteers'] ?? 0,
      totalZones: map['totalZones'] ?? 0,
      totalArea: (map['totalArea'] ?? 0.0).toDouble(),
      totalParticipations: map['totalParticipations'] ?? 0,
      participationByActivity: Map<String, int>.from(map['participationByActivity'] ?? {}),
      zoneStats: Map<String, Map<String, dynamic>>.from(map['zoneStats'] ?? {}),
      currentMonthHours: map['currentMonthHours'] ?? 0,
      previousMonthHours: map['previousMonthHours'] ?? 0,
    );
  }
}