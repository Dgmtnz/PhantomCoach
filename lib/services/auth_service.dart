import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phantom_coach/config/app_config.dart';
import 'package:phantom_coach/models/user_model.dart' as app;

class AuthService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      ...AppConfig.googleSheetsScopes,
    ],
  );

  // Get current user from Firebase
  firebase.User? get currentUser => _firebaseAuth.currentUser;

  // Authentication state changes stream
  Stream<firebase.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return false;
      
      // Check if the token is valid
      await currentUser.getIdToken(true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign in with email and password
  Future<app.User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to sign in');
      }
      
      // Get user profile data from your backend or create a new one
      final user = await _getUserProfile(userCredential.user!);
      
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<app.User> registerWithEmailAndPassword(
    String email, 
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to register');
      }
      
      // Update the user's display name
      await userCredential.user!.updateDisplayName(displayName);
      
      // Create a new user profile
      final user = _createNewUserProfile(userCredential.user!, displayName);
      
      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign in with Google
  Future<app.User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in was canceled');
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }
      
      // Get user profile or create a new one
      final user = await _getUserProfile(userCredential.user!);
      
      return user;
    } catch (e) {
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.userTokenKey);
      await prefs.remove(AppConfig.userProfileKey);
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  // Get user profile from backend or local storage
  Future<app.User> _getUserProfile(firebase.User firebaseUser) async {
    try {
      // Try to get from local storage first
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConfig.userProfileKey);
      
      if (userJson != null) {
        try {
          return app.User.fromJson(Map<String, dynamic>.from(
            // ignore: no_leading_underscores_for_local_identifiers
            // ignore: inference_failure_on_untyped_parameter
            _parseJson(userJson),
          ));
        } catch (_) {
          // If parsing fails, continue to create a new profile
        }
      }
      
      // If not found, create a new profile
      return _createNewUserProfile(firebaseUser, firebaseUser.displayName ?? 'User');
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  // Create a new user profile
  app.User _createNewUserProfile(firebase.User firebaseUser, String displayName) {
    final newUser = app.User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: displayName,
      photoUrl: firebaseUser.photoURL,
      profile: app.UserProfile(),
      preferences: app.UserPreferences(),
      spreadsheetIds: [],
    );
    
    // Save to local storage
    _saveUserProfile(newUser);
    
    return newUser;
  }

  // Save user profile to local storage
  Future<void> _saveUserProfile(app.User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.userProfileKey, _stringifyJson(user.toJson()));
    } catch (e) {
      throw Exception('Failed to save user profile: ${e.toString()}');
    }
  }

  // Parse JSON string
  dynamic _parseJson(String jsonString) {
    return jsonString;
  }

  // Stringify JSON
  String _stringifyJson(Map<String, dynamic> json) {
    return json.toString();
  }
} 