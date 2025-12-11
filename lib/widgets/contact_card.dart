import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  String get _initials {
    final parts = contact.name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(scheme),
            const SizedBox(width: 12),
            Expanded(child: _buildTextContent(scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme scheme) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        _initials,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildTextContent(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameRow(scheme),
        const SizedBox(height: 4),
        _buildRoleRow(),
        const SizedBox(height: 6),
        _buildConferenceRow(),
        const SizedBox(height: 6),
        _buildNoteRow(),
      ],
    );
  }

  Widget _buildNameRow(ColorScheme scheme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            contact.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          Icons.badge_outlined,
          size: 18,
          color: scheme.primary,
        ),
      ],
    );
  }

  Widget _buildRoleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.work_outline, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${contact.role} · ${contact.company}',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildConferenceRow() {
    return Row(
      children: [
        const Icon(Icons.event_outlined, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Chip(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            label: Text(
              contact.conference,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.notes_outlined, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            contact.note,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
