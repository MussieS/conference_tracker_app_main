import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../models/contact.dart';
import '../widgets/contact_card.dart';
import '../widgets/contact_sheet.dart';

class ConferenceContactsScreen extends StatelessWidget {
  const ConferenceContactsScreen({super.key});

  FirestoreService get _firestore => FirestoreService();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.4),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 12),
            Expanded(child: _buildContactsStream()),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  /// --- App bar & header ---

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Conference Contacts'),
      centerTitle: true,
      leading: const Icon(Icons.badge_outlined),
      actions: [
        IconButton(
          tooltip: 'Seed demo contacts',
          icon: const Icon(Icons.cloud_upload_outlined),
          onPressed: () async {
            await _firestore.seedDemoContacts();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Demo contacts synced to Firestore.')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                Icons.people_alt_rounded,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'People I met at conferences',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Purpose: Track recruiters, speakers, and other people you meet at conferences and their conversations.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- Body: contacts list ---

  Widget _buildContactsStream() {
    return StreamBuilder<List<Contact>>(
      stream: _firestore.contactsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final contacts = snapshot.data ?? [];

        if (contacts.isEmpty) {
          return const Center(
            child: Text(
              'No contacts yet.\nTap the + button to add one or use the cloud icon for demo data.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return _buildContactsList(contacts);
      },
    );
  }

  Widget _buildContactsList(List<Contact> contacts) {
    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return ContactCard(contact: contacts[index]);
      },
    );
  }

  /// --- Float button to add contact & bottom sheet ---

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openAddContactSheet(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.person_add),
    );
  }

  void _openAddContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: AddContactSheet(firestoreService: _firestore),
        );
      },
    );
  }
}
