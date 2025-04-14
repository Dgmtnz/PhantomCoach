import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:phantom_coach/models/workout_model.dart';
import 'package:phantom_coach/services/sheets_service.dart';

class WorkoutProvider with ChangeNotifier {
  final SheetsService _sheetsService;
  
  List<Routine> _routines = [];
  Routine? _currentRoutine;
  WorkoutSession? _activeWorkoutSession;
  List<WorkoutSession> _workoutHistory = [];
  bool _isLoading = false;
  String? _error;
  Timer? _workoutTimer;
  int _elapsedSeconds = 0;
  
  // Constructor
  WorkoutProvider(this._sheetsService);
  
  // Getters
  List<Routine> get routines => _routines;
  Routine? get currentRoutine => _currentRoutine;
  WorkoutSession? get activeWorkoutSession => _activeWorkoutSession;
  List<WorkoutSession> get workoutHistory => _workoutHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isWorkoutActive => _activeWorkoutSession != null;
  int get elapsedSeconds => _elapsedSeconds;
  
  String get formattedElapsedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Load routines
  Future<void> loadRoutines() async {
    try {
      _setLoading(true);
      _clearError();
      
      // In a real app, you would fetch routines from the backend or database
      // For now, let's create some sample routines
      _routines = _createSampleRoutines();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Load workout history
  Future<void> loadWorkoutHistory() async {
    try {
      _setLoading(true);
      _clearError();
      
      // In a real app, you would fetch workout history from the backend or database
      // For now, let's just use an empty list
      _workoutHistory = [];
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Set current routine
  void setCurrentRoutine(Routine routine) {
    _currentRoutine = routine;
    notifyListeners();
  }
  
  // Start workout
  Future<void> startWorkout(String userId) async {
    try {
      if (_currentRoutine == null) {
        throw Exception('No routine selected');
      }
      
      final now = DateTime.now();
      
      // Create a new workout session
      _activeWorkoutSession = WorkoutSession(
        id: 'ws_${now.millisecondsSinceEpoch}',
        routineId: _currentRoutine!.id,
        userId: userId,
        startTime: now,
        completedExercises: [],
      );
      
      // Start the workout timer
      _startWorkoutTimer();
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Start an exercise
  Future<void> startExercise(Exercise exercise) async {
    try {
      if (_activeWorkoutSession == null) {
        throw Exception('No active workout session');
      }
      
      // Create a new completed exercise
      final completedExercise = CompletedExercise(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        sets: [],
        startTime: DateTime.now(),
      );
      
      // Add to the active workout session
      _activeWorkoutSession = _activeWorkoutSession!.copyWith(
        completedExercises: [
          ..._activeWorkoutSession!.completedExercises,
          completedExercise,
        ],
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Complete a set
  Future<void> completeSet(String exerciseId, ExerciseSet set, {int? actualReps, double? actualWeight}) async {
    try {
      if (_activeWorkoutSession == null) {
        throw Exception('No active workout session');
      }
      
      // Find the completed exercise
      final exerciseIndex = _activeWorkoutSession!.completedExercises.indexWhere(
        (e) => e.exerciseId == exerciseId,
      );
      
      if (exerciseIndex == -1) {
        throw Exception('Exercise not found in active workout');
      }
      
      // Create a completed set
      final completedSet = CompletedSet(
        setNumber: set.setNumber,
        reps: actualReps ?? set.reps,
        weightKg: actualWeight ?? set.weightKg,
        durationSeconds: set.durationSeconds,
        notes: set.notes,
      );
      
      // Update the active workout session
      final updatedExercises = [..._activeWorkoutSession!.completedExercises];
      final currentExercise = updatedExercises[exerciseIndex];
      
      updatedExercises[exerciseIndex] = currentExercise.copyWith(
        sets: [...currentExercise.sets, completedSet],
      );
      
      _activeWorkoutSession = _activeWorkoutSession!.copyWith(
        completedExercises: updatedExercises,
      );
      
      // Mark the set as completed
      set.isCompleted = true;
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Finish exercise
  Future<void> finishExercise(String exerciseId) async {
    try {
      if (_activeWorkoutSession == null) {
        throw Exception('No active workout session');
      }
      
      // Find the completed exercise
      final exerciseIndex = _activeWorkoutSession!.completedExercises.indexWhere(
        (e) => e.exerciseId == exerciseId,
      );
      
      if (exerciseIndex == -1) {
        throw Exception('Exercise not found in active workout');
      }
      
      // Update the end time
      final updatedExercises = [..._activeWorkoutSession!.completedExercises];
      final currentExercise = updatedExercises[exerciseIndex];
      
      updatedExercises[exerciseIndex] = currentExercise.copyWith(
        endTime: DateTime.now(),
      );
      
      _activeWorkoutSession = _activeWorkoutSession!.copyWith(
        completedExercises: updatedExercises,
      );
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Finish workout
  Future<void> finishWorkout({int? caloriesBurned, String? notes}) async {
    try {
      if (_activeWorkoutSession == null) {
        throw Exception('No active workout session');
      }
      
      final now = DateTime.now();
      final duration = now.difference(_activeWorkoutSession!.startTime);
      
      // Calculate total weight lifted
      double totalWeightLifted = 0;
      for (final exercise in _activeWorkoutSession!.completedExercises) {
        for (final set in exercise.sets) {
          if (set.weightKg != null) {
            totalWeightLifted += set.weightKg! * set.reps;
          }
        }
      }
      
      // Update the workout session
      _activeWorkoutSession = _activeWorkoutSession!.copyWith(
        endTime: now,
        totalDurationMinutes: duration.inMinutes,
        totalWeightLifted: totalWeightLifted,
        caloriesBurned: caloriesBurned,
        notes: notes,
      );
      
      // Add to history
      _workoutHistory.add(_activeWorkoutSession!);
      
      // Save to Google Sheets
      try {
        // TODO: Save to Google Sheets
        // await _sheetsService.saveWorkoutSession(spreadsheetId, _activeWorkoutSession!);
      } catch (e) {
        print('Error saving workout to Google Sheets: $e');
      }
      
      // Stop the timer
      _stopWorkoutTimer();
      
      // Clear the active workout
      _activeWorkoutSession = null;
      _elapsedSeconds = 0;
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Cancel workout
  void cancelWorkout() {
    _stopWorkoutTimer();
    _activeWorkoutSession = null;
    _elapsedSeconds = 0;
    notifyListeners();
  }
  
  // Start workout timer
  void _startWorkoutTimer() {
    _workoutTimer?.cancel();
    _elapsedSeconds = 0;
    
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }
  
  // Stop workout timer
  void _stopWorkoutTimer() {
    _workoutTimer?.cancel();
    _workoutTimer = null;
  }
  
  // Create sample routines
  List<Routine> _createSampleRoutines() {
    return [
      Routine(
        id: 'routine_1',
        name: 'Full Body Workout',
        description: 'A complete full body workout targeting all major muscle groups.',
        createdBy: 'system',
        isDefault: true,
        exercises: [
          Exercise(
            id: 'ex_1',
            name: 'Barbell Squat',
            description: 'A compound exercise that targets the quadriceps, hamstrings, and glutes.',
            category: 'Legs',
            muscleGroups: ['Quadriceps', 'Hamstrings', 'Glutes'],
            equipment: ['Barbell', 'Squat Rack'],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 12, weightKg: 60),
              ExerciseSet(setNumber: 2, reps: 10, weightKg: 70),
              ExerciseSet(setNumber: 3, reps: 8, weightKg: 80),
            ],
            restBetweenSets: 90,
          ),
          Exercise(
            id: 'ex_2',
            name: 'Bench Press',
            description: 'A compound exercise that targets the chest, shoulders, and triceps.',
            category: 'Chest',
            muscleGroups: ['Chest', 'Shoulders', 'Triceps'],
            equipment: ['Barbell', 'Bench'],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 12, weightKg: 50),
              ExerciseSet(setNumber: 2, reps: 10, weightKg: 60),
              ExerciseSet(setNumber: 3, reps: 8, weightKg: 70),
            ],
            restBetweenSets: 90,
          ),
          Exercise(
            id: 'ex_3',
            name: 'Bent Over Row',
            description: 'A compound exercise that targets the back and biceps.',
            category: 'Back',
            muscleGroups: ['Back', 'Biceps'],
            equipment: ['Barbell'],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 12, weightKg: 40),
              ExerciseSet(setNumber: 2, reps: 10, weightKg: 50),
              ExerciseSet(setNumber: 3, reps: 8, weightKg: 60),
            ],
            restBetweenSets: 90,
          ),
        ],
        category: 'Strength',
        difficulty: 'Intermediate',
        estimatedDurationMinutes: 60,
        createdAt: DateTime.now(),
      ),
      Routine(
        id: 'routine_2',
        name: 'Upper Body Focus',
        description: 'A workout targeting the upper body muscles.',
        createdBy: 'system',
        isDefault: true,
        exercises: [
          Exercise(
            id: 'ex_4',
            name: 'Pull-ups',
            description: 'A bodyweight exercise that targets the back and biceps.',
            category: 'Back',
            muscleGroups: ['Back', 'Biceps'],
            equipment: ['Pull-up Bar'],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 10),
              ExerciseSet(setNumber: 2, reps: 8),
              ExerciseSet(setNumber: 3, reps: 6),
            ],
            restBetweenSets: 90,
          ),
          Exercise(
            id: 'ex_5',
            name: 'Push-ups',
            description: 'A bodyweight exercise that targets the chest, shoulders, and triceps.',
            category: 'Chest',
            muscleGroups: ['Chest', 'Shoulders', 'Triceps'],
            equipment: [],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 15),
              ExerciseSet(setNumber: 2, reps: 12),
              ExerciseSet(setNumber: 3, reps: 10),
            ],
            restBetweenSets: 60,
          ),
          Exercise(
            id: 'ex_6',
            name: 'Dumbbell Shoulder Press',
            description: 'An exercise that targets the shoulders and triceps.',
            category: 'Shoulders',
            muscleGroups: ['Shoulders', 'Triceps'],
            equipment: ['Dumbbells'],
            isCompound: true,
            sets: [
              ExerciseSet(setNumber: 1, reps: 12, weightKg: 15),
              ExerciseSet(setNumber: 2, reps: 10, weightKg: 17.5),
              ExerciseSet(setNumber: 3, reps: 8, weightKg: 20),
            ],
            restBetweenSets: 90,
          ),
        ],
        category: 'Strength',
        difficulty: 'Beginner',
        estimatedDurationMinutes: 45,
        createdAt: DateTime.now(),
      ),
    ];
  }
  
  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
  
  // Dispose
  @override
  void dispose() {
    _stopWorkoutTimer();
    super.dispose();
  }
} 