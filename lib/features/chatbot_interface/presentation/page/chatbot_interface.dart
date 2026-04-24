import 'package:flutter/material.dart';
import 'package:psychora/core/network/api_service.dart';
import 'package:psychora/features/chatbot_interface/presentation/function/chatservices.dart';
import 'package:psychora/features/chatbot_interface/presentation/widget/chatinterface_form.dart';
import 'package:psychora/features/patient_dashboard/data/patient_notes_store.dart';

class ChatbotInterface extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const ChatbotInterface({
    super.key,
    this.patientId,
    this.patientName,
  });

  @override
  State<ChatbotInterface> createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface> {
  final ApiService _apiService = ApiService();
  final PatientNotesStore _patientNotesStore = PatientNotesStore();
  final ChatServices _chatServices = ChatServices();
  Future<void> _openPatientNotesEditor() async {
    final String patientId = (widget.patientId ?? '').trim();
    if (patientId.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a patient before writing notes.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String patientName = (widget.patientName ?? '').trim();
    final TextEditingController noteController = TextEditingController(
      text: _patientNotesStore.getNote(patientId),
    );

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            patientName.isEmpty ? 'Notes patient' : 'Notes - $patientName',
          ),
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
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      noteController.dispose();
      return;
    }

    if (shouldSave == true) {
      final String normalized = noteController.text.trim();

      if (normalized.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Write a note before saving.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        noteController.dispose();
        return;
      }

      try {
        await _apiService.savePatientNote(
          patientId: patientId,
          note: normalized,
        );
      } catch (_) {
        if (!mounted) {
          noteController.dispose();
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save patient notes.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        noteController.dispose();
        return;
      }

      _patientNotesStore.saveNote(
        patientId: patientId,
        patientName: patientName,
        note: normalized,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes saved.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.patientName == null || widget.patientName!.trim().isEmpty
              ? 'Psychora Chatbot'
              : 'Chat - ${widget.patientName!.trim()}',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _openPatientNotesEditor();
            },
            tooltip: 'Write patient notes',
            icon: const Icon(
              Icons.note_add_outlined,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ChatinterfaceForm(
            patientId: widget.patientId,
            patientName: widget.patientName,
          ),
        ),
      ),
    );
  }
}