import 'package:flutter/material.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

class HeaderText extends StatelessWidget {
  final List<PatientModel> filteredPatients;
  const HeaderText({super.key, required this.filteredPatients});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes Patients',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${filteredPatients.length} patient${filteredPatients.length > 1 ? 's' : ''} disponible${filteredPatients.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
