class Child {
  final String id;
  final String? clientId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? nickname;
  final DateTime dateOfBirth;
  final String gender;
  final String? raceEthnicity;
  final String? preferredLanguage;
  final String? photoUrl;

  // Identifiers
  final String? ssn;
  final String? medicaidId;
  final String? schoolId;

  // Status & Custody
  final String status;
  final String? custodyStatus;
  final String? legalStatus;

  // Referral Information
  final String? referralSource;
  final String? referralReason;
  final String? presentingIssues;

  // Medical & Health (JSON arrays)
  final List<dynamic>? medications;
  final List<dynamic>? allergies;
  final List<dynamic>? medicalConditions;
  final List<dynamic>? mentalHealthDx;

  // Behavioral & Emotional
  final List<dynamic>? triggers;
  final List<dynamic>? copingMechanisms;
  final String? traumaHistory;
  final String? attachmentStyle;

  // Interests & Strengths
  final List<dynamic>? interests;
  final List<dynamic>? strengths;
  final List<dynamic>? likes;
  final List<dynamic>? dislikes;
  final List<dynamic>? fears;

  // Emergency Contacts
  final List<dynamic>? emergencyContacts;

  // Family
  final String? familyId;
  final Family? family;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;

  // Computed properties
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get fullName => '$firstName ${middleName ?? ''} $lastName'.trim();
  String get displayName => nickname ?? firstName;

  Child({
    required this.id,
    this.clientId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.nickname,
    required this.dateOfBirth,
    required this.gender,
    this.raceEthnicity,
    this.preferredLanguage,
    this.photoUrl,
    this.ssn,
    this.medicaidId,
    this.schoolId,
    required this.status,
    this.custodyStatus,
    this.legalStatus,
    this.referralSource,
    this.referralReason,
    this.presentingIssues,
    this.medications,
    this.allergies,
    this.medicalConditions,
    this.mentalHealthDx,
    this.triggers,
    this.copingMechanisms,
    this.traumaHistory,
    this.attachmentStyle,
    this.interests,
    this.strengths,
    this.likes,
    this.dislikes,
    this.fears,
    this.emergencyContacts,
    this.familyId,
    this.family,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      clientId: json['clientId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      nickname: json['nickname'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      raceEthnicity: json['raceEthnicity'],
      preferredLanguage: json['preferredLanguage'],
      photoUrl: json['photoUrl'],
      ssn: json['ssn'],
      medicaidId: json['medicaidId'],
      schoolId: json['schoolId'],
      status: json['status'] ?? 'Active',
      custodyStatus: json['custodyStatus'],
      legalStatus: json['legalStatus'],
      referralSource: json['referralSource'],
      referralReason: json['referralReason'],
      presentingIssues: json['presentingIssues'],
      medications: json['medications'],
      allergies: json['allergies'],
      medicalConditions: json['medicalConditions'],
      mentalHealthDx: json['mentalHealthDx'],
      triggers: json['triggers'],
      copingMechanisms: json['copingMechanisms'],
      traumaHistory: json['traumaHistory'],
      attachmentStyle: json['attachmentStyle'],
      interests: json['interests'],
      strengths: json['strengths'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      fears: json['fears'],
      emergencyContacts: json['emergencyContacts'],
      familyId: json['familyId'],
      family: json['family'] != null ? Family.fromJson(json['family']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'raceEthnicity': raceEthnicity,
      'preferredLanguage': preferredLanguage,
      'photoUrl': photoUrl,
      'ssn': ssn,
      'medicaidId': medicaidId,
      'schoolId': schoolId,
      'status': status,
      'custodyStatus': custodyStatus,
      'legalStatus': legalStatus,
      'referralSource': referralSource,
      'referralReason': referralReason,
      'presentingIssues': presentingIssues,
      'medications': medications,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'mentalHealthDx': mentalHealthDx,
      'triggers': triggers,
      'copingMechanisms': copingMechanisms,
      'traumaHistory': traumaHistory,
      'attachmentStyle': attachmentStyle,
      'interests': interests,
      'strengths': strengths,
      'likes': likes,
      'dislikes': dislikes,
      'fears': fears,
      'emergencyContacts': emergencyContacts,
      'familyId': familyId,
    };
  }
}

class Family {
  final String id;
  final String familyName;
  final String? primaryContact;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;

  // Living Situation
  final String? housingType;
  final String? housingStatus;
  final String? householdIncome;
  final String? employmentStatus;

  // Family Dynamics (JSON)
  final List<dynamic>? familyComposition;
  final List<dynamic>? supportNetwork;
  final List<dynamic>? familyStressors;
  final List<dynamic>? familyStrengths;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  Family({
    required this.id,
    required this.familyName,
    this.primaryContact,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.housingType,
    this.housingStatus,
    this.householdIncome,
    this.employmentStatus,
    this.familyComposition,
    this.supportNetwork,
    this.familyStressors,
    this.familyStrengths,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'],
      familyName: json['familyName'],
      primaryContact: json['primaryContact'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      housingType: json['housingType'],
      housingStatus: json['housingStatus'],
      householdIncome: json['householdIncome'],
      employmentStatus: json['employmentStatus'],
      familyComposition: json['familyComposition'],
      supportNetwork: json['supportNetwork'],
      familyStressors: json['familyStressors'],
      familyStrengths: json['familyStrengths'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'familyName': familyName,
      'primaryContact': primaryContact,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'housingType': housingType,
      'housingStatus': housingStatus,
      'householdIncome': householdIncome,
      'employmentStatus': employmentStatus,
      'familyComposition': familyComposition,
      'supportNetwork': supportNetwork,
      'familyStressors': familyStressors,
      'familyStrengths': familyStrengths,
    };
  }
}
