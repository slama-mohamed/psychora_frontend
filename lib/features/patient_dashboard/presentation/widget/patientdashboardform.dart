import 'package:flutter/material.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';
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
  late List<PatientModel> _allPatients;
  late List<PatientModel> _filteredPatients;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializePatients();
    _filteredPatients = _allPatients;
    _searchController.addListener(_filterPatients);
  }

  void _initializePatients() {
    _allPatients = [
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

  @override
  void dispose() {
    _searchController.dispose();
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Continuer chat avec ${patient.name}',
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            ),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}