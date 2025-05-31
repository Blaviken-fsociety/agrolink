// workshop.dart
class Workshop {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int maxParticipants;
  final int participants;

  Workshop({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.maxParticipants,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'maxParticipants': maxParticipants,
      'participants': participants,
    };
  }

  factory Workshop.fromMap(Map<String, dynamic> map, String id) {
    return Workshop(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      maxParticipants: map['maxParticipants'] ?? 0,
      participants: map['participants'] ?? 0,
    );
  }
}