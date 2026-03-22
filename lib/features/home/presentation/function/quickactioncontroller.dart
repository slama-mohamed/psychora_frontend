import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/features/home/presentation/widget/add_patient_dialog.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

class QuickActionController {
  /// Ouvre le dialog d'ajout de patient et retourne le `PatientModel` créé.
  /// Retourne `null` si l'utilisateur annule.
  static Future<PatientModel?> openAddPatientDialog(BuildContext context) async {
    final result = await showDialog<PatientModel>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddPatientDialog(),
    );

    return result;
  }

  static void handleNavigateToChat(BuildContext context) {
    context.pushNamed(RouteName.chatbotinterface);
  }

  
}