class Task {
  final String id;
  final String zoneId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String assignedTo; // puede ser el userId
  final bool completed;

  Task({
    required this.id,
    required this.zoneId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedTo,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'zoneId': zoneId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'assignedTo': assignedTo,
      'completed': completed,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      zoneId: map['zoneId'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      assignedTo: map['assignedTo'],
      completed: map['completed'],
    );
  }
}