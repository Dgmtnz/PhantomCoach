import 'package:intl/intl.dart';

class Routine {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final bool isDefault;
  final List<Exercise> exercises;
  final int restBetweenExercises;
  final String category;
  final String difficulty;
  final int estimatedDurationMinutes;
  final DateTime createdAt;
  final DateTime? lastUsed;

  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    this.isDefault = false,
    required this.exercises,
    this.restBetweenExercises = 90,
    required this.category,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required this.createdAt,
    this.lastUsed,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdBy: json['createdBy'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      restBetweenExercises: json['restBetweenExercises'] as int? ?? 90,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'isDefault': isDefault,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'restBetweenExercises': restBetweenExercises,
      'category': category,
      'difficulty': difficulty,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  Routine copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    bool? isDefault,
    List<Exercise>? exercises,
    int? restBetweenExercises,
    String? category,
    String? difficulty,
    int? estimatedDurationMinutes,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      isDefault: isDefault ?? this.isDefault,
      exercises: exercises ?? this.exercises,
      restBetweenExercises: restBetweenExercises ?? this.restBetweenExercises,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> muscleGroups;
  final List<String> equipment;
  final bool isCompound;
  final List<ExerciseSet> sets;
  final int restBetweenSets;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    required this.muscleGroups,
    required this.equipment,
    this.isCompound = false,
    required this.sets,
    this.restBetweenSets = 60,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      muscleGroups: List<String>.from(json['muscleGroups'] as List),
      equipment: List<String>.from(json['equipment'] as List),
      isCompound: json['isCompound'] as bool? ?? false,
      sets: (json['sets'] as List)
          .map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      restBetweenSets: json['restBetweenSets'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'muscleGroups': muscleGroups,
      'equipment': equipment,
      'isCompound': isCompound,
      'sets': sets.map((e) => e.toJson()).toList(),
      'restBetweenSets': restBetweenSets,
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    String? videoUrl,
    List<String>? muscleGroups,
    List<String>? equipment,
    bool? isCompound,
    List<ExerciseSet>? sets,
    int? restBetweenSets,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      equipment: equipment ?? this.equipment,
      isCompound: isCompound ?? this.isCompound,
      sets: sets ?? this.sets,
      restBetweenSets: restBetweenSets ?? this.restBetweenSets,
    );
  }
}

class ExerciseSet {
  final int setNumber;
  final int reps;
  final double? weightKg;
  final int? durationSeconds;
  final String? notes;
  bool isCompleted;

  ExerciseSet({
    required this.setNumber,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    this.notes,
    this.isCompleted = false,
  });

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      setNumber: json['setNumber'] as int,
      reps: json['reps'] as int,
      weightKg: json['weightKg'] as double?,
      durationSeconds: json['durationSeconds'] as int?,
      notes: json['notes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weightKg': weightKg,
      'durationSeconds': durationSeconds,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  ExerciseSet copyWith({
    int? setNumber,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    String? notes,
    bool? isCompleted,
  }) {
    return ExerciseSet(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WorkoutSession {
  final String id;
  final String routineId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<CompletedExercise> completedExercises;
  final double? totalWeightLifted;
  final int? totalDurationMinutes;
  final int? caloriesBurned;
  final String? notes;

  WorkoutSession({
    required this.id,
    required this.routineId,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.completedExercises,
    this.totalWeightLifted,
    this.totalDurationMinutes,
    this.caloriesBurned,
    this.notes,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      completedExercises: (json['completedExercises'] as List)
          .map((e) => CompletedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalWeightLifted: json['totalWeightLifted'] as double?,
      totalDurationMinutes: json['totalDurationMinutes'] as int?,
      caloriesBurned: json['caloriesBurned'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineId': routineId,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'completedExercises': completedExercises.map((e) => e.toJson()).toList(),
      'totalWeightLifted': totalWeightLifted,
      'totalDurationMinutes': totalDurationMinutes,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
    };
  }

  String get formattedDate {
    return DateFormat('MMMM d, yyyy').format(startTime);
  }

  String get formattedTime {
    return DateFormat('h:mm a').format(startTime);
  }

  String get duration {
    if (endTime == null) return "In progress";
    final difference = endTime!.difference(startTime);
    return "${difference.inMinutes} min";
  }

  WorkoutSession copyWith({
    String? id,
    String? routineId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    List<CompletedExercise>? completedExercises,
    double? totalWeightLifted,
    int? totalDurationMinutes,
    int? caloriesBurned,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completedExercises: completedExercises ?? this.completedExercises,
      totalWeightLifted: totalWeightLifted ?? this.totalWeightLifted,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      notes: notes ?? this.notes,
    );
  }
}

class CompletedExercise {
  final String exerciseId;
  final String exerciseName;
  final List<CompletedSet> sets;
  final DateTime startTime;
  final DateTime? endTime;

  CompletedExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.startTime,
    this.endTime,
  });

  factory CompletedExercise.fromJson(Map<String, dynamic> json) {
    return CompletedExercise(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as List)
          .map((e) => CompletedSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets.map((e) => e.toJson()).toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  CompletedExercise copyWith({
    String? exerciseId,
    String? exerciseName,
    List<CompletedSet>? sets,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return CompletedExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class CompletedSet {
  final int setNumber;
  final int reps;
  final double? weightKg;
  final int? durationSeconds;
  final String? notes;

  CompletedSet({
    required this.setNumber,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    this.notes,
  });

  factory CompletedSet.fromJson(Map<String, dynamic> json) {
    return CompletedSet(
      setNumber: json['setNumber'] as int,
      reps: json['reps'] as int,
      weightKg: json['weightKg'] as double?,
      durationSeconds: json['durationSeconds'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setNumber': setNumber,
      'reps': reps,
      'weightKg': weightKg,
      'durationSeconds': durationSeconds,
      'notes': notes,
    };
  }

  CompletedSet copyWith({
    int? setNumber,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    String? notes,
  }) {
    return CompletedSet(
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
    );
  }
} 