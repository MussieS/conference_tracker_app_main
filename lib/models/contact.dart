class Contact {
  final String name;
  final String role;
  final String company;
  final String conference;
  final String note;
  final String? linkedinUrl;


  const Contact({
    required this.name,
    required this.role,
    required this.company,
    required this.conference,
    required this.note,
    this.linkedinUrl,
  });

  factory Contact.fromMap(Map<String, dynamic> data) {
    return Contact(
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      company: data['company'] ?? '',
      conference: data['conference'] ?? '',
      note: data['note'] ?? '',
      linkedinUrl: data['linkedinUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'company': company,
      'conference': conference,
      'note': note,
      if (linkedinUrl != null && linkedinUrl!.isNotEmpty)
        'linkedinUrl': linkedinUrl,
    };
  }
}

/// Demo contacts used to seed Firestore
const List<Contact> demoContacts = [
  Contact(
    name: 'Sam Johnson',
    role: 'Actuarial Analyst',
    company: 'Jewelers Mutual',
    conference: 'GIS Annual Conference 2025',
    note:
    'We discussed using my expenditure analysis project to study claim frequencies.',
    linkedinUrl: 'https://www.linkedin.com/in/sample-sam',
  ),
  Contact(
    name: 'Alex Lee',
    role: 'Recruiter',
    company: 'Milliman',
    conference: 'IABA Conference 2025',
    note: 'Talked about importance of Exam P and predictive analytics internship.',
    linkedinUrl: 'https://www.linkedin.com/in/sample-alex',
  ),
  Contact(
    name: 'Taylor Brown',
    role: 'Data Scientist',
    company: 'InsureTech Labs',
    conference: 'Tech & Insurance Summit',
    note: 'Discussed Python, R, and modeling claim severity distributions.',
  ),
];
