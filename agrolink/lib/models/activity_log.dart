class ActivityLog {
  final String id;
  final String userId;
  final String taskId;
  final String zoneId;
  final String title;
  final String description;
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.zoneId,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskId': taskId,
      'zoneId': zoneId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActivityLog.fromMap(String id, Map<String, dynamic> map) {
    return ActivityLog(
      id: id,
      userId: map['userId'],
      taskId: map['taskId'],
      zoneId: map['zoneId'],
      title: map['title'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}