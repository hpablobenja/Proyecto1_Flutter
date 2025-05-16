class SubjectModel {
  final int id;
  final String name;
  final String schedule;

  SubjectModel({required this.id, required this.name, required this.schedule});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'schedule': schedule};
  }

  static SubjectModel fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'],
      name: map['name'],
      schedule: map['schedule'],
    );
  }
}
