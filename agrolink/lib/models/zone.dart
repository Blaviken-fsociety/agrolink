class Zone {
  final String id;
  final String name;
  final double size;
  final String cropType;
  final String status;

  Zone({
    required this.id,
    required this.name,
    required this.size,
    required this.cropType,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'size': size,
      'cropType': cropType,
      'status': status,
    };
  }

  factory Zone.fromMap(String id, Map<String, dynamic> map) {
    return Zone(
      id: id,
      name: map['name'],
      size: map['size'],
      cropType: map['cropType'],
      status: map['status'],
    );
  }
}