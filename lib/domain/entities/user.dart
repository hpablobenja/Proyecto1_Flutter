class User {
  final int id;
  final String identificationCode;
  final String name;
  final String type; // "Maestro" o "Estudiante"
  final String? assignedQrCode;

  User({
    required this.id,
    required this.identificationCode,
    required this.name,
    required this.type,
    this.assignedQrCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identificationCode': identificationCode,
      'name': name,
      'type': type,
      'assignedQrCode': assignedQrCode,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      identificationCode: map['identificationCode'],
      name: map['name'],
      type: map['type'],
      assignedQrCode: map['assignedQrCode'],
    );
  }
}
