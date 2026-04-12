import 'package:flutter/material.dart';
import 'package:psychora/features/patient_dashboard/data/patientmodel.dart';

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({super.key});

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _conditionController = TextEditingController();
  final _lastSeenController = TextEditingController(text: 'Aujourd\'hui');
  final _sessionsController = TextEditingController(text: '0');

  bool _isSubmitting = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _conditionController.dispose();
    _lastSeenController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final int? parsedAge = int.tryParse(_ageController.text.trim());
    if (parsedAge == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final newPatient = PatientModel(
      id: _idController.text.trim().isEmpty
          ? 'P${DateTime.now().millisecondsSinceEpoch % 100000}'
          : _idController.text.trim(),
      name: _nameController.text.trim(),
        age: parsedAge,
      condition: _conditionController.text.trim(),
      lastSeen: _lastSeenController.text.trim(),
      sessionsCount: int.tryParse(_sessionsController.text.trim()) ?? 0,
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text('Patient ajouté : ${newPatient.name}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      ),
    );

    Navigator.of(context).pop(newPatient);
  }

  InputDecoration _fieldDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: Row(
        children: const [
          Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF1F2937)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Add New Patient',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: _fieldDecoration('ID Patient', 'Ex: P007'),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null; // id auto-généré si vide
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: _fieldDecoration(
                  'Nom complet',
                  'Ex: Sara El Moussa',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                decoration: _fieldDecoration('Âge', 'Ex: 29'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'L\'âge est requis';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Saisir un âge valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _conditionController,
                decoration: _fieldDecoration(
                  'Diagnostic / état',
                  'Ex: Trouble d\'anxiété generalisée',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le diagnostic est requis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastSeenController,
                decoration: _fieldDecoration(
                  'Dernière visite',
                  'Ex: 2 jours ago',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La date de dernière visite est requise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sessionsController,
                decoration: _fieldDecoration('Nombre de séances', 'Ex: 8'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nombre de séances est requis';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Saisir un nombre valide';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Exit' , style: TextStyle(color: Colors.black),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D9970),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(100, 40),
          ),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Add' , style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
