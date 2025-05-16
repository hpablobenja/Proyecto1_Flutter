import '../../core/constants/database_constants.dart';

class SubjectModel {
  final int? id; // Puede ser nulo si es un nuevo registro aún no guardado
  final String name;
  final String schedule;
  final DateTime? createdAt;

  SubjectModel({
    this.id,
    required this.name,
    required this.schedule,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnSubjectName: name,
      DatabaseConstants.columnSchedule: schedule,
      DatabaseConstants.columnCreatedAt: createdAt?.toIso8601String(),
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map[DatabaseConstants.columnId] as int?,
      name: map[DatabaseConstants.columnSubjectName] as String,
      schedule: map[DatabaseConstants.columnSchedule] as String,
      createdAt:
          map[DatabaseConstants.columnCreatedAt] != null
              ? DateTime.parse(map[DatabaseConstants.columnCreatedAt] as String)
              : null,
    );
  }
}
