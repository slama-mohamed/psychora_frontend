class PatientNotesStore {
  PatientNotesStore._internal();

  static final PatientNotesStore _instance = PatientNotesStore._internal();

  factory PatientNotesStore() => _instance;

  final Map<String, String> _notesByPatientId = <String, String>{};

  String getNote(String patientId) {
    return _notesByPatientId[patientId] ?? '';
  }

  void saveNote({
    required String patientId,
    required String note,
  }) {
    final String normalized = note.trim();
    if (normalized.isEmpty) {
      _notesByPatientId.remove(patientId);
      return;
    }

    _notesByPatientId[patientId] = note;
  }
}
