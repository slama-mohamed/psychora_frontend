class PatientModel {
  final String id;
  final String name;
  final int age;
  final String condition;
  final String lastSeen;
  final int sessionsCount;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.condition,
    required this.lastSeen,
    required this.sessionsCount,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    int? age,
    String? condition,
    String? lastSeen,
    int? sessionsCount,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      lastSeen: lastSeen ?? this.lastSeen,
      sessionsCount: sessionsCount ?? this.sessionsCount,
    );
  }
}