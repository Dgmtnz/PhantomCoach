import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phantom_coach/screens/auth/login_screen.dart';
import 'package:phantom_coach/screens/auth/register_screen.dart';
import 'package:phantom_coach/screens/dashboard/dashboard_screen.dart';
import 'package:phantom_coach/screens/splash_screen.dart';
import 'package:phantom_coach/screens/welcome_screen.dart';
import 'package:phantom_coach/services/auth_service.dart';

class AppRouter {
  static final AuthService _authService = AuthService();
  
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // For now, we'll simplify the redirect logic while developing
      return null;
    },
    routes: [
      // Initial route - splash screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Home/welcome screen
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
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
    ],
    errorBuilder: (context, state) => const WelcomeScreen(),
  );
} 