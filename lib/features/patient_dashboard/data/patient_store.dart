import 'package:flutter/foundation.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

class PatientStore {
  PatientStore._internal()
      : patientsNotifier = ValueNotifier<List<PatientModel>>(
          List<PatientModel>.of(_seedPatients),
        );

  static final PatientStore _instance = PatientStore._internal();

  factory PatientStore() => _instance;

  final ValueNotifier<List<PatientModel>> patientsNotifier;

  List<PatientModel> get currentPatients => List<PatientModel>.of(patientsNotifier.value);

  void addPatient(PatientModel patient) {
    final List<PatientModel> updatedPatients = <PatientModel>[
      patient,
      ...patientsNotifier.value,
    ];
    patientsNotifier.value = updatedPatients;
  }

  void removePatientById(String patientId) {
    final List<PatientModel> updatedPatients = patientsNotifier.value
        .where((PatientModel patient) => patient.id != patientId)
        .toList();
    patientsNotifier.value = updatedPatients;
  }

  static final List<PatientModel> _seedPatients = <PatientModel>[
    PatientModel(
      id: 'P001',
      name: 'Mohamed Slama',
      age: '28 years',
      condition: 'Major Depressive Disorder',
      lastSeen: '1 week ago',
      sessionsCount: 8,
    ),
    PatientModel(
      id: 'P002',
      name: 'Nour Mnif',
      age: '22 years',
      condition: 'Generalized Anxiety Disorder',
      lastSeen: '3 days ago',
      sessionsCount: 5,
    ),
    PatientModel(
      id: 'P003',
      name: 'Ilef Boualleg',
      age: '26 years',
      condition: 'PTSD',
      lastSeen: '5 days ago',
      sessionsCount: 6,
    ),
    PatientModel(
      id: 'P004',
      name: 'Amira Mohamed',
      age: '30 years',
      condition: 'Sleep Disorder',
      lastSeen: '2 days ago',
      sessionsCount: 9,
    ),
    PatientModel(
      id: 'P005',
      name: 'Ali Ibrahim',
      age: '35 years',
      condition: 'Stress Management',
      lastSeen: '1 month ago',
      sessionsCount: 15,
    ),
  ];
}
