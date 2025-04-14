import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:phantom_coach/config/routes.dart';
import 'package:phantom_coach/config/theme.dart';
import 'package:phantom_coach/providers/auth_provider.dart';
import 'package:phantom_coach/providers/workout_provider.dart';
import 'package:phantom_coach/providers/nutrition_provider.dart';
import 'package:phantom_coach/providers/settings_provider.dart';
import 'package:phantom_coach/services/auth_service.dart';
import 'package:phantom_coach/services/sheets_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "YOUR_API_KEY", // Replace with your Firebase API key
      authDomain: "your-app.firebaseapp.com", // Replace with your Firebase auth domain
      projectId: "your-app", // Replace with your Firebase project ID
      storageBucket: "your-app.appspot.com", // Replace with your storage bucket
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID", // Replace with your messaging sender ID
      appId: "YOUR_APP_ID", // Replace with your Firebase app ID
    ),
  );

  // Run the app
  runApp(const PhantomCoachApp());
}

class PhantomCoachApp extends StatelessWidget {
  const PhantomCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()),
        ),
        
        // Workout provider
        ChangeNotifierProvider(
          create: (_) => WorkoutProvider(SheetsService()),
        ),
        
        // Nutrition provider
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(SheetsService()),
        ),
        
        // Settings provider
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: 'Phantom Coach',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme, // TODO: Create a dark theme
            themeMode: settings.themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
