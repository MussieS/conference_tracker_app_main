import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../widgets/contact_sheet.dart';
import 'conference_contacts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  FirestoreService get _firestore => FirestoreService();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.4),
      appBar: AppBar(
        title: const Text('Conference Contacts'),
        centerTitle: true,
        leading: const Icon(Icons.home_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildIntroCard(context),
            const SizedBox(height: 16),
            _buildChoiceButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const Expanded(
              child: Text(
                'Welcome! Track people you meet at actuarial and tech conferences.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButtons(BuildContext context) {
    return Column(
      children: [
        _buildChoiceCard(
          context: context,
          icon: Icons.list_alt_outlined,
          title: 'View saved contacts',
          subtitle: 'Browse everyone you have already added.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ConferenceContactsScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          icon: Icons.person_add_alt_1_outlined,
          title: 'Add a new contact',
          subtitle: 'Quickly add someone you just met.',
          onTap: () => _openAddContactSheet(context),
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  icon,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
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
