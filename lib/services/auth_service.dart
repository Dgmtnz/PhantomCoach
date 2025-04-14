import 'package:phantom_coach/models/user_model.dart';

// Service for authentication - currently mocked for development
class AuthService {
  User? _currentUser;

  // Getter for current user
  User? get currentUser => _currentUser;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    // For development, we'll assume the user is not logged in
    return false;
  }

  // Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    // For development, we'll just create a mock user
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request

    // For development, any credentials work
    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      displayName: 'Demo User',
      photoUrl: null,
      profile: UserProfile(
        height: 180, 
        weight: 75,
        birthDate: DateTime(1990, 1, 1),
        gender: 'Male',
        activityLevel: 'Moderate',
        fitnessGoal: 'Build Muscle',
      ),
      preferences: UserPreferences(
        useMetricSystem: true,
        darkModeEnabled: false,
        notificationsEnabled: true,
      ),
    );

    return _currentUser!;
  }

  // Register with email and password
  Future<User> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    // For development, we'll just create a mock user
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request

    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      displayName: displayName,
      photoUrl: null,
      profile: UserProfile(
        height: 180, 
        weight: 75,
        birthDate: DateTime(1990,), 
        gender: 'Not specified',
        activityLevel: 'Moderate',
        fitnessGoal: 'General Fitness',
      ),
      preferences: UserPreferences(
        useMetricSystem: true,
        darkModeEnabled: false,
        notificationsEnabled: true,
      ),
    );

    return _currentUser!;
  }

  // Sign in with Google
  Future<User> signInWithGoogle() async {
    // For development, we'll just create a mock user
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request

    _currentUser = User(
      id: 'mock-google-user-id',
      email: 'demo@example.com',
      displayName: 'Google User',
      photoUrl: null,
      profile: UserProfile(
        height: 175, 
        weight: 70,
        birthDate: DateTime(1992, 5, 15), 
        gender: 'Not specified',
        activityLevel: 'Active',
        fitnessGoal: 'Lose Weight',
      ),
      preferences: UserPreferences(
        useMetricSystem: true,
        darkModeEnabled: false,
        notificationsEnabled: true,
      ),
    );

    return _currentUser!;
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    _currentUser = null;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    // For development, we'll just simulate this action
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    // No action needed in the mock implementation
  }
} 