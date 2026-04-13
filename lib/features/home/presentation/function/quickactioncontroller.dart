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

    PatientModel? createdPatient;

    if (result != null) {
      try {
        final response = await _apiService.addPatient(
          name: result.name,
          age: result.age,
          condition: result.condition,
          lastSeen: result.lastSeen,
          sessionsCount: result.sessionsCount,
        );

        final String patientId = _extractPatientId(response.data);
        createdPatient = PatientModel(
          id: patientId,
          name: result.name,
          age: result.age,
          condition: result.condition,
          lastSeen: result.lastSeen,
          sessionsCount: result.sessionsCount,
        );

        _patientStore.addPatient(createdPatient);
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

    return createdPatient ?? result;
  }

  static void handleNavigateToChat(BuildContext context) {
    context.pushNamed(RouteName.chatbotinterface);
  }

  static void handleNavigateToResources(BuildContext context) {
    context.goNamed(RouteName.resourcesPage);
  }

  static String _extractPatientId(dynamic responseData) {
    if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    if (responseData is Map<String, dynamic>) {
      final dynamic directId = responseData['id'] ?? responseData['patientId'];
      if (directId is String && directId.isNotEmpty) {
        return directId;
      }

      for (final String key in <String>['data', 'patient', 'result']) {
        final String nestedId = _extractPatientId(responseData[key]);
        if (nestedId.isNotEmpty) {
          return nestedId;
        }
      }
    }

    throw StateError('Backend response did not include a patient id.');
  }
}