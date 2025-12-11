import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contact.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _contactsRef =
  FirebaseFirestore.instance.collection('contacts');

  /// Stream of contacts ordered by name
  Stream<List<Contact>> contactsStream() {
    return _contactsRef
        .orderBy('name')
        .snapshots()
        .map(_mapSnapshotToContacts);
  }

  List<Contact> _mapSnapshotToContacts(
      QuerySnapshot<Map<String, dynamic>> snapshot,
      ) {
    return snapshot.docs.map((doc) {
      return Contact.fromMap(doc.data());
    }).toList();
  }

  /// Add a new contact
  Future<void> addContact(Contact contact) {
    return _contactsRef.add(contact.toMap());
  }

  /// Seed Firestore with demo contacts (only once)
  Future<void> seedDemoContacts() async {
    final existing = await _contactsRef.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    for (final c in demoContacts) {
      await _contactsRef.add(c.toMap());
    }
  }
}
