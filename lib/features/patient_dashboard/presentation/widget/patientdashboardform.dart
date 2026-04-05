import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';
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
          title: const Text('Supprimer patient'),
          content: Text('Supprimer ${patient.name} de la liste des patients ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    _patientStore.removePatientById(patient.id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient supprimé: ${patient.name}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
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
                              ? 'Aucun patient disponible'
                              : 'Aucun patient trouvé',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Commencez à ajouter des patients'
                              : 'Essayez une autre recherche',
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
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Profil: ${patient.name}',
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}