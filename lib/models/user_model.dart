class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserProfile profile;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.profile,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'profile': profile.toJson(),
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    UserProfile? profile,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserProfile {
  final double height; // in cm
  final double weight; // in kg
  final DateTime birthDate;
  final String gender;
  final String activityLevel;
  final String fitnessGoal;

  UserProfile({
    this.height = 170.0,
    this.weight = 70.0,
    DateTime? birthDate,
    this.gender = 'Not specified',
    this.activityLevel = 'Moderate',
    this.fitnessGoal = 'General Fitness',
  }) : birthDate = birthDate ?? DateTime(1990, 1, 1);

  // Calculate age
  int get age {
    final today = DateTime.now();
    final age = today.year - birthDate.year;
    final monthDiff = today.month - birthDate.month;
    
    if (monthDiff < 0 || (monthDiff == 0 && today.day < birthDate.day)) {
      return age - 1;
    }
    
    return age;
  }

  // Calculate BMI
  double get bmi {
    if (height <= 0 || weight <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    double? height,
    double? weight,
    DateTime? birthDate,
    String? gender,
    String? activityLevel,
    String? fitnessGoal,
  }) {
    return UserProfile(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      height: json['height'] as double? ?? 170.0,
      weight: json['weight'] as double? ?? 70.0,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String? ?? 'Not specified',
      activityLevel: json['activityLevel'] as String? ?? 'Moderate',
      fitnessGoal: json['fitnessGoal'] as String? ?? 'General Fitness',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'activityLevel': activityLevel,
      'fitnessGoal': fitnessGoal,
    };
  }
}

class UserPreferences {
  final bool useMetricSystem;
  final bool darkModeEnabled;
  final bool notificationsEnabled;

  UserPreferences({
    this.useMetricSystem = true,
    this.darkModeEnabled = false,
    this.notificationsEnabled = true,
  });

  // Create a copy with updated fields
  UserPreferences copyWith({
    bool? useMetricSystem,
    bool? darkModeEnabled,
    bool? notificationsEnabled,
  }) {
    return UserPreferences(
      useMetricSystem: useMetricSystem ?? this.useMetricSystem,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      useMetricSystem: json['useMetricSystem'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'useMetricSystem': useMetricSystem,
      'darkModeEnabled': darkModeEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }
} 