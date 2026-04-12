import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psychora/core/constants/route_name.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/home/presentation/widget/add_patient_dialog.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';
import 'package:psychora/features/patient_dashboard/data/patient_store.dart';

class QuickActionController {
  static final PatientStore _patientStore = PatientStore();
  static final ApiService _apiService = ApiService();

  /// Ouvre le dialog d'ajout de patient et retourne le `PatientModel` créé.
  /// Retourne `null` si l'utilisateur annule.
  static Future<PatientModel?> openAddPatientDialog(BuildContext context) async {
    final result = await showDialog<PatientModel>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddPatientDialog(),
    );

    if (result != null) {
      try {
        await _apiService.addPatient(
          id: result.id,
          name: result.name,
          age: result.age,
          condition: result.condition,
          lastSeen: result.lastSeen,
          sessionsCount: result.sessionsCount,
        );
        _patientStore.addPatient(result);
      } catch (_) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.hideCurrentSnackBar();
        messenger?.showSnackBar(
          const SnackBar(
            content: Text('Echec de l\'ajout du patient sur le serveur.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return null;
      }
    }

    return result;
  }

  static void handleNavigateToChat(BuildContext context) {
    context.pushNamed(RouteName.chatbotinterface);
  }

  static void handleNavigateToResources(BuildContext context) {
    context.goNamed(RouteName.resourcesPage);
  }

  
}