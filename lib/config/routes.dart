import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phantom_coach/screens/auth/login_screen.dart';
import 'package:phantom_coach/screens/auth/register_screen.dart';
import 'package:phantom_coach/screens/dashboard/dashboard_screen.dart';
import 'package:phantom_coach/screens/workout/routine_selection_screen.dart';
import 'package:phantom_coach/screens/workout/routine_creator_screen.dart';
import 'package:phantom_coach/screens/workout/workout_screen.dart';
import 'package:phantom_coach/screens/nutrition/calorie_counter_screen.dart';
import 'package:phantom_coach/screens/nutrition/meal_planner_screen.dart';
import 'package:phantom_coach/screens/progress/progress_screen.dart';
import 'package:phantom_coach/screens/settings/settings_screen.dart';
import 'package:phantom_coach/screens/settings/profile_screen.dart';
import 'package:phantom_coach/screens/splash_screen.dart';
import 'package:phantom_coach/services/auth_service.dart';

class AppRouter {
  static final AuthService _authService = AuthService();
  
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final bool isLoggedIn = await _authService.isLoggedIn();
      final bool isGoingToLogin = state.matchedLocation == '/login' || 
                                  state.matchedLocation == '/register';
      
      // If not logged in and not going to login page, redirect to login
      if (!isLoggedIn && !isGoingToLogin && state.matchedLocation != '/') {
        return '/login';
      }
      
      // If logged in and going to login page, redirect to dashboard
      if (isLoggedIn && isGoingToLogin) {
        return '/dashboard';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Splash screen route
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app routes
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      
      // Workout routes
      GoRoute(
        path: '/routines',
        builder: (context, state) => const RoutineSelectionScreen(),
      ),
      GoRoute(
        path: '/routine/create',
        builder: (context, state) => const RoutineCreatorScreen(),
      ),
      GoRoute(
        path: '/routine/:id',
        builder: (context, state) {
          final routineId = state.pathParameters['id']!;
          return WorkoutScreen(routineId: routineId);
        },
      ),
      
      // Nutrition routes
      GoRoute(
        path: '/calories',
        builder: (context, state) => const CalorieCounterScreen(),
      ),
      GoRoute(
        path: '/meals',
        builder: (context, state) => const MealPlannerScreen(),
      ),
      
      // Progress tracking route
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      
      // Settings routes
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
} 