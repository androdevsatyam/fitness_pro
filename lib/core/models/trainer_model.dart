enum VerificationStatus {
  draft,
  submitted,
  underReview,
  changesRequested,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case VerificationStatus.draft:
        return 'Draft';
      case VerificationStatus.submitted:
        return 'Submitted';
      case VerificationStatus.underReview:
        return 'Under Admin Review';
      case VerificationStatus.changesRequested:
        return 'Changes Requested';
      case VerificationStatus.approved:
        return 'Verified & Approved';
      case VerificationStatus.rejected:
        return 'Application Rejected';
    }
  }
}

class Qualification {
  final String id;
  final String certName;
  final String issuingOrg;
  final String certNumber;
  final String issueDate;
  final String expiryDate;
  final String documentUrl;
  final bool isVerified;

  const Qualification({
    required this.id,
    required this.certName,
    required this.issuingOrg,
    required this.certNumber,
    required this.issueDate,
    required this.expiryDate,
    this.documentUrl = '',
    this.isVerified = true,
  });
}

class ServiceOffering {
  final String id;
  final String title;
  final String description;
  final String category; // Yoga, Functional, Strength, Mobility, Women's, etc.
  final int durationMinutes;
  final double priceInr;
  final String sessionType; // 1-on-1 Personal or Small Group
  final String equipmentProvided;
  final String equipmentRequired;
  final double travelSurchargeInr;

  const ServiceOffering({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationMinutes,
    required this.priceInr,
    this.sessionType = '1-on-1 Personal',
    this.equipmentProvided = 'Resistance bands, agility cones, yoga mat',
    this.equipmentRequired = 'Towel & water bottle',
    this.travelSurchargeInr = 100,
  });
}

class WeeklySlot {
  final int dayOfWeek; // 1 = Mon, 7 = Sun
  final String startTime;
  final String endTime;
  final bool isEnabled;

  const WeeklySlot({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isEnabled = true,
  });
}

class TrainerModel {
  final String id;
  final String name;
  final String headline;
  final String bio;
  final String photoUrl;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final List<String> languages;
  final String city;
  final List<String> serviceAreas;
  final double maxTravelRadiusKm;
  final List<String> preferredTrainingLocations; // Home, Park, Society Gym
  final VerificationStatus verificationStatus;
  final bool idVerified; // Aadhaar / PAN verified status
  final List<Qualification> qualifications;
  final List<ServiceOffering> services;
  final List<WeeklySlot> availability;
  final bool instantBookingEnabled;
  final bool isProfilePaused;
  final String nextAvailableSlot;
  final double totalEarningsInr;
  final int completedSessionsCount;
  final String gender;

  const TrainerModel({
    required this.id,
    required this.name,
    required this.headline,
    required this.bio,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.languages,
    required this.city,
    required this.serviceAreas,
    this.maxTravelRadiusKm = 10.0,
    required this.preferredTrainingLocations,
    this.verificationStatus = VerificationStatus.approved,
    this.idVerified = true,
    required this.qualifications,
    required this.services,
    this.availability = const [],
    this.instantBookingEnabled = true,
    this.isProfilePaused = false,
    this.nextAvailableSlot = 'Today, 5:30 PM',
    this.totalEarningsInr = 42500,
    this.completedSessionsCount = 38,
    this.gender = 'Any',
  });

  TrainerModel copyWith({
    String? id,
    String? name,
    String? headline,
    String? bio,
    String? photoUrl,
    double? rating,
    int? reviewCount,
    int? experienceYears,
    List<String>? languages,
    String? city,
    List<String>? serviceAreas,
    double? maxTravelRadiusKm,
    List<String>? preferredTrainingLocations,
    VerificationStatus? verificationStatus,
    bool? idVerified,
    List<Qualification>? qualifications,
    List<ServiceOffering>? services,
    List<WeeklySlot>? availability,
    bool? instantBookingEnabled,
    bool? isProfilePaused,
    String? nextAvailableSlot,
    double? totalEarningsInr,
    int? completedSessionsCount,
    String? gender,
  }) {
    return TrainerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experienceYears: experienceYears ?? this.experienceYears,
      languages: languages ?? this.languages,
      city: city ?? this.city,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      maxTravelRadiusKm: maxTravelRadiusKm ?? this.maxTravelRadiusKm,
      preferredTrainingLocations:
          preferredTrainingLocations ?? this.preferredTrainingLocations,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      idVerified: idVerified ?? this.idVerified,
      qualifications: qualifications ?? this.qualifications,
      services: services ?? this.services,
      availability: availability ?? this.availability,
      instantBookingEnabled:
          instantBookingEnabled ?? this.instantBookingEnabled,
      isProfilePaused: isProfilePaused ?? this.isProfilePaused,
      nextAvailableSlot: nextAvailableSlot ?? this.nextAvailableSlot,
      totalEarningsInr: totalEarningsInr ?? this.totalEarningsInr,
      completedSessionsCount:
          completedSessionsCount ?? this.completedSessionsCount,
      gender: gender ?? this.gender,
    );
  }
}

