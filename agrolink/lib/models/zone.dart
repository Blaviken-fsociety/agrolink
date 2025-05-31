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
    try {
      return Zone(
        id: id,
        name: _parseString(map['name'], 'Zona sin nombre'),
        size: _parseDouble(map['size']),
        cropType: _parseString(map['cropType'], 'Sin especificar'),
        status: _parseString(map['status'], 'Sin estado'),
      );
    } catch (e) {
      print('Error al crear Zone desde map: $e');
      print('Datos recibidos: $map');
      rethrow;
    }
  }

  // Método auxiliar para convertir cualquier valor a String de forma segura
  static String _parseString(dynamic value, String defaultValue) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  // Método auxiliar para convertir cualquier valor a double de forma segura
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    
    return 0.0;
  }

  // Método para validar que una zona tenga datos válidos
  bool isValid() {
    return name.isNotEmpty && 
           size > 0 && 
           cropType.isNotEmpty && 
           status.isNotEmpty;
  }

  @override
  String toString() {
    return 'Zone(id: $id, name: $name, size: $size, cropType: $cropType, status: $status)';
  }
}