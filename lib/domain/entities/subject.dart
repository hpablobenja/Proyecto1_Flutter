class Subject {
  final int id;
  final String name;
  final String schedule;

  Subject({required this.id, required this.name, required this.schedule});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'schedule': schedule};
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(id: map['id'], name: map['name'], schedule: map['schedule']);
  }
}
