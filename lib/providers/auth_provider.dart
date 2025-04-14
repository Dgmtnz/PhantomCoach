import 'package:flutter/foundation.dart';
import 'package:phantom_coach/models/user_model.dart';
import 'package:phantom_coach/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService);

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      _setLoading(true);
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn && _currentUser == null) {
        // If we're logged in but don't have the user details yet, fetch them
        await _fetchCurrentUser();
      }
      
      _setLoading(false);
      return isLoggedIn;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();
      
      _currentUser = await _authService.signInWithGoogle();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _setLoading(true);
      _clearError();
      
      _currentUser = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.signOut();
      _currentUser = null;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _authService.resetPassword(email);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Fetch current user
  Future<void> _fetchCurrentUser() async {
    try {
      // This would typically call an API or fetch from the auth service
      // For now, we're just using the Firebase user
      if (_authService.currentUser != null) {
        // Setup would go here to fetch user profile from backend or construct user object
        // In a real app, you might want to fetch additional user data from a database
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Update the user profile
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(profile: updatedProfile);
        
        // In a real app, you would persist these changes to a backend or database
        
        _setLoading(false);
        notifyListeners();
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(UserPreferences updatedPreferences) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Update the user preferences
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(preferences: updatedPreferences);
        
        // In a real app, you would persist these changes to a backend or database
        
        _setLoading(false);
        notifyListeners();
      } else {
        throw Exception('No user is currently logged in');
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
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
} 