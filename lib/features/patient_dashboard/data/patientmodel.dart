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
}