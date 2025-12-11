import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../services/firestore_service.dart';

class AddContactSheet extends StatefulWidget {
  final FirestoreService firestoreService;

  const AddContactSheet({super.key, required this.firestoreService});

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _companyController = TextEditingController();
  final _conferenceController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _companyController.dispose();
    _conferenceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final contact = Contact(
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      company: _companyController.text.trim(),
      conference: _conferenceController.text.trim(),
      note: _noteController.text.trim(),
    );

    await widget.firestoreService.addContact(contact);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact added.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 12.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGrabHandle(scheme),
              _buildTitleRow(),
              const SizedBox(height: 12),
              _buildTextFields(),
              const SizedBox(height: 12),
              _buildSaveButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrabHandle(ColorScheme scheme) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.outlineVariant,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      children: const [
        Icon(Icons.person_add_alt_1_outlined),
        SizedBox(width: 8),
        Text(
          'Add Contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Name',
          icon: Icons.person_outline,
          requiredField: true,
        ),
        _buildTextField(
          controller: _roleController,
          label: 'Role',
          icon: Icons.work_outline,
        ),
        _buildTextField(
          controller: _companyController,
          label: 'Company',
          icon: Icons.business_outlined,
        ),
        _buildTextField(
          controller: _conferenceController,
          label: 'Conference',
          icon: Icons.event_outlined,
        ),
        _buildTextField(
          controller: _noteController,
          label: 'Note about the conversation',
          icon: Icons.notes_outlined,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isSaving ? null : _onSavePressed,
        icon: _isSaving
            ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : const Icon(Icons.save_outlined),
        label: const Text('Save contact'),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool requiredField = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: requiredField
            ? (value) =>
        (value == null || value.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }
}
