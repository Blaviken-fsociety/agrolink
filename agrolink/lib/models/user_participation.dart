// user_participation.dart
class UserParticipation {
  final String userId;
  final int totalHours;
  final int totalActivities;
  final int currentMonthHours;
  final int activeZones;
  final String level;
  final List<Map<String, dynamic>> recentActivities;
  final List<Map<String, dynamic>> achievements;

  UserParticipation({
    required this.userId,
    required this.totalHours,
    required this.totalActivities,
    required this.currentMonthHours,
    required this.activeZones,
    required this.level,
    required this.recentActivities,
    required this.achievements,
  });

  factory UserParticipation.fromMap(Map<String, dynamic> map, String userId) {
    return UserParticipation(
      userId: userId,
      totalHours: map['totalHours'] ?? 0,
      totalActivities: map['totalActivities'] ?? 0,
      currentMonthHours: map['currentMonthHours'] ?? 0,
      activeZones: map['activeZones'] ?? 0,
      level: map['level'] ?? 'Principiante',
      recentActivities: List<Map<String, dynamic>>.from(map['recentActivities'] ?? []),
      achievements: List<Map<String, dynamic>>.from(map['achievements'] ?? []),
    );
  }
}