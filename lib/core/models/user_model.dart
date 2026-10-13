enum UserRole {
  customer,
  trainer,
  admin,
  support;

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.trainer:
        return 'Trainer';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.support:
        return 'Support Agent';
    }
  }
}

class CustomerPreferences {
  final String primaryGoal;
  final String trainingStyle;
  final String experienceLevel;
  final int preferredDurationMinutes;
  final String preferredTimeWindow;
  final double budgetPerSession;
  final String preferredLanguage;
  final String sessionFormat; // In-person or Online
  final List<String> exerciseLimitations;

  const CustomerPreferences({
    this.primaryGoal = 'Weight Management & Fat Loss',
    this.trainingStyle = 'Functional & HIIT',
    this.experienceLevel = 'Intermediate',
    this.preferredDurationMinutes = 60,
    this.preferredTimeWindow = 'Morning (6 AM - 9 AM)',
    this.budgetPerSession = 1200,
    this.preferredLanguage = 'English / Hindi',
    this.sessionFormat = 'In-Person (Home/Society)',
    this.exerciseLimitations = const [],
  });

  CustomerPreferences copyWith({
    String? primaryGoal,
    String? trainingStyle,
    String? experienceLevel,
    int? preferredDurationMinutes,
    String? preferredTimeWindow,
    double? budgetPerSession,
    String? preferredLanguage,
    String? sessionFormat,
    List<String>? exerciseLimitations,
  }) {
    return CustomerPreferences(
      primaryGoal: primaryGoal ?? this.primaryGoal,
      trainingStyle: trainingStyle ?? this.trainingStyle,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      preferredDurationMinutes:
          preferredDurationMinutes ?? this.preferredDurationMinutes,
      preferredTimeWindow: preferredTimeWindow ?? this.preferredTimeWindow,
      budgetPerSession: budgetPerSession ?? this.budgetPerSession,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sessionFormat: sessionFormat ?? this.sessionFormat,
      exerciseLimitations: exerciseLimitations ?? this.exerciseLimitations,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String avatarUrl;
  final String city;
  final String area;
  final CustomerPreferences? preferences;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl = '',
    this.city = 'Bengaluru',
    this.area = 'Koramangala',
    this.preferences,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    String? city,
    String? area,
    CustomerPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      area: area ?? this.area,
      preferences: preferences ?? this.preferences,
    );
  }
}

