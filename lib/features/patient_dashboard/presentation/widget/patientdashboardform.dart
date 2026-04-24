import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/home/presentation/widget/add_patient_dialog.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/barre_de_recherche.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/header_text.dart';
import 'package:psychora/features/patient_dashboard/presentation/widget/patient_card.dart';



class Patientdashboardform extends StatefulWidget {
  const Patientdashboardform({super.key});

  @override
  State<Patientdashboardform> createState() => _PatientdashboardformState();
}

class _PatientdashboardformState extends State<Patientdashboardform> {
  late TextEditingController _searchController;
  final PatientStore _patientStore = PatientStore();
  final PatientNotesStore _patientNotesStore = PatientNotesStore();
  final ApiService _apiService = ApiService();
  late List<PatientModel> _allPatients;
  late List<PatientModel> _filteredPatients;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _allPatients = _patientStore.currentPatients;
    _filteredPatients = _allPatients;
    _searchController.addListener(_filterPatients);
    _patientStore.patientsNotifier.addListener(_handlePatientsChanged);
    _loadPatientsFromServer();
    _loadNotesFromServer();
  }

  Future<void> _loadNotesFromServer() async {
    try {
      final notes = await _apiService.getPatientNotes();
      if (!mounted) {
        return;
      }
      _patientNotesStore.setNotes(notes);
    } catch (_) {
      // Keep silent here: notes are secondary content for this page.
    }
  }

  Future<void> _loadPatientsFromServer() async {
    try {
      final List<PatientModel> patients = await _apiService.getPatients();
      if (!mounted) {
        return;
      }
      _patientStore.setPatients(patients);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load patients from the database.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handlePatientsChanged() {
    _allPatients = _patientStore.currentPatients;
    _filterPatients();
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPatients = _allPatients.where((patient) {
        return patient.name.toLowerCase().contains(query) ||
            patient.id.toLowerCase().contains(query) ||
            patient.condition.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _confirmAndDeletePatient(PatientModel patient) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete patient'),
          content: Text('Remove ${patient.name} from the patient list?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _apiService.deletePatient(patientId: patient.id);
      _patientStore.removePatientById(patient.id);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete ${patient.name} on the server.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient deleted: ${patient.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmAndUpdatePatient(PatientModel patient) async {
    final PatientModel? updatedPatient = await showDialog<PatientModel>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddPatientDialog(initialPatient: patient),
    );

    if (updatedPatient == null) {
      return;
    }

    try {
      await _apiService.updatePatient(
        patientId: patient.id,
        name: updatedPatient.name,
        age: updatedPatient.age,
        condition: updatedPatient.condition,
        lastSeen: updatedPatient.lastSeen,
        sessionsCount: updatedPatient.sessionsCount,
      );
      _patientStore.updatePatient(updatedPatient.copyWith(id: patient.id));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update ${patient.name} on the server.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient updated: ${updatedPatient.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openPatientNotesEditor(PatientModel patient) async {
    final TextEditingController noteController = TextEditingController(
      text: _patientNotesStore.getNote(patient.id),
    );

    final bool? isSaved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notes - ${patient.name}'),
          content: TextField(
            controller: noteController,
            maxLines: 8,
            minLines: 5,
            decoration: const InputDecoration(
              hintText: 'Write notes for this patient...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      noteController.dispose();
      return;
    }

    if (isSaved == true) {
      final String normalized = noteController.text.trim();

      try {
        await _apiService.savePatientNote(
          patientId: patient.id,
          note: normalized,
        );
      } catch (_) {
        if (!mounted) {
          noteController.dispose();
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save notes for ${patient.name}.'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
        noteController.dispose();
        return;
      }

      _patientNotesStore.saveNote(
        patientId: patient.id,
        patientName: patient.name,
        note: normalized,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notes saved for ${patient.name}.'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    noteController.dispose();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _patientStore.patientsNotifier.removeListener(_handlePatientsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
          HeaderText(filteredPatients: _filteredPatients),

          // Barre de recherche
          BarreDeRecherche(
            controller: _searchController,
            onChanged: (_) {
              _filterPatients();
            },
          ),

          // Liste des patients
          Expanded(
            child: _filteredPatients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_search_rounded,
                            size: 56,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No patients available'
                              : 'No patients found',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Start adding patients'
                              : 'Try another search',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      return PatientCard(
                        patientName: patient.name,
                        patientId: patient.id,
                        age: patient.age,
                        condition: patient.condition,
                        lastSeen: patient.lastSeen,
                        sessionsCount: patient.sessionsCount,
                        onContinueChat: () {
                          context.pushNamed(
                            RouteName.chatbotinterface,
                            extra: <String, dynamic>{
                              'patientId': patient.id,
                              'patientName': patient.name,
                            },
                          );
                        },
                        onEdit: () {
                          _confirmAndUpdatePatient(patient);
                        },
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Profile: ${patient.name}',
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onDelete: () {
                          _confirmAndDeletePatient(patient);
                        },
                        onSummary: () {
                          _openPatientNotesEditor(patient);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}