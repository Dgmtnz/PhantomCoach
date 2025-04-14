class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserProfile profile;
  final UserPreferences preferences;
  final List<String> spreadsheetIds;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.profile,
    required this.preferences,
    required this.spreadsheetIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      spreadsheetIds: List<String>.from(json['spreadsheetIds'] as List),
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
      'spreadsheetIds': spreadsheetIds,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    UserProfile? profile,
    UserPreferences? preferences,
    List<String>? spreadsheetIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      spreadsheetIds: spreadsheetIds ?? this.spreadsheetIds,
    );
  }
}

class UserProfile {
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final String? gender;
  final String? activityLevel;
  final double? targetWeightKg;
  final String? fitnessGoal;
  final int? workoutsPerWeek;

  UserProfile({
    this.age,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.activityLevel,
    this.targetWeightKg,
    this.fitnessGoal,
    this.workoutsPerWeek,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: json['age'] as int?,
      heightCm: json['heightCm'] as double?,
      weightKg: json['weightKg'] as double?,
      gender: json['gender'] as String?,
      activityLevel: json['activityLevel'] as String?,
      targetWeightKg: json['targetWeightKg'] as double?,
      fitnessGoal: json['fitnessGoal'] as String?,
      workoutsPerWeek: json['workoutsPerWeek'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'gender': gender,
      'activityLevel': activityLevel,
      'targetWeightKg': targetWeightKg,
      'fitnessGoal': fitnessGoal,
      'workoutsPerWeek': workoutsPerWeek,
    };
  }

  UserProfile copyWith({
    int? age,
    double? heightCm,
    double? weightKg,
    String? gender,
    String? activityLevel,
    double? targetWeightKg,
    String? fitnessGoal,
    int? workoutsPerWeek,
  }) {
    return UserProfile(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      workoutsPerWeek: workoutsPerWeek ?? this.workoutsPerWeek,
    );
  }
}

class UserPreferences {
  final bool isDarkMode;
  final bool useMetricSystem;
  final bool showCalories;
  final int restTimerSoundLevel;
  final List<String> favoritedRoutines;
  final bool enableNotifications;
  final Map<String, dynamic> notificationSettings;

  UserPreferences({
    this.isDarkMode = false,
    this.useMetricSystem = true,
    this.showCalories = true,
    this.restTimerSoundLevel = 7,
    this.favoritedRoutines = const [],
    this.enableNotifications = true,
    this.notificationSettings = const {
      'workout_reminder': true,
      'weekly_summary': true,
      'goal_achieved': true,
    },
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      useMetricSystem: json['useMetricSystem'] as bool? ?? true,
      showCalories: json['showCalories'] as bool? ?? true,
      restTimerSoundLevel: json['restTimerSoundLevel'] as int? ?? 7,
      favoritedRoutines: List<String>.from(json['favoritedRoutines'] as List? ?? []),
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      notificationSettings: json['notificationSettings'] as Map<String, dynamic>? ?? {
        'workout_reminder': true,
        'weekly_summary': true,
        'goal_achieved': true,
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'useMetricSystem': useMetricSystem,
      'showCalories': showCalories,
      'restTimerSoundLevel': restTimerSoundLevel,
      'favoritedRoutines': favoritedRoutines,
      'enableNotifications': enableNotifications,
      'notificationSettings': notificationSettings,
    };
  }

  UserPreferences copyWith({
    bool? isDarkMode,
    bool? useMetricSystem,
    bool? showCalories,
    int? restTimerSoundLevel,
    List<String>? favoritedRoutines,
    bool? enableNotifications,
    Map<String, dynamic>? notificationSettings,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useMetricSystem: useMetricSystem ?? this.useMetricSystem,
      showCalories: showCalories ?? this.showCalories,
      restTimerSoundLevel: restTimerSoundLevel ?? this.restTimerSoundLevel,
      favoritedRoutines: favoritedRoutines ?? this.favoritedRoutines,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }
} 