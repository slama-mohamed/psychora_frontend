class PatientNoteModel {
  final String patientId;
  final String patientName;
  final String note;
  final DateTime updatedAt;

  const PatientNoteModel({
    required this.patientId,
    required this.patientName,
    required this.note,
    required this.updatedAt,
  });

  factory PatientNoteModel.fromMap(Map<String, dynamic> map) {
    final String patientId = (map['patientId'] ?? map['patient_id'] ?? map['id'] ?? '')
        .toString();
    final String patientName =
        (map['patientName'] ?? map['patient_name'] ?? map['name'] ?? '').toString();
    final String note = (map['note'] ?? map['content'] ?? map['text'] ?? '').toString();

    final dynamic dateValue = map['updatedAt'] ?? map['updated_at'] ?? map['createdAt'];
    DateTime updatedAt = DateTime.now();
    if (dateValue is String) {
      updatedAt = DateTime.tryParse(dateValue) ?? DateTime.now();
    }

    return PatientNoteModel(
      patientId: patientId,
      patientName: patientName,
      note: note,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'patientId': patientId,
      'patientName': patientName,
      'note': note,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PatientNoteModel copyWith({
    String? patientId,
    String? patientName,
    String? note,
    DateTime? updatedAt,
  }) {
    return PatientNoteModel(
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
