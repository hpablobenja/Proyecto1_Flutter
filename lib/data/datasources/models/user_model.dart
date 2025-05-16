class UserModel {
  final int id;
  final String identificationCode;
  final String name;
  final String type;
  final String? qrCode;

  UserModel({
    required this.id,
    required this.identificationCode,
    required this.name,
    required this.type,
    this.qrCode,
  });

  bool get isTeacher => type == 'Teacher';
  bool get isStudent => type == 'Student';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identification_code': identificationCode,
      'name': name,
      'type': type,
      'qr_code': qrCode,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      identificationCode: map['identification_code'],
      name: map['name'],
      type: map['type'],
      qrCode: map['qr_code'],
    );
  }
}
