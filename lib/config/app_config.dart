class AppConfig {
  // App information
  static const String appName = 'Phantom Coach';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.yourapp.com';
  
  // Google Sheets API scopes
  static const List<String> googleSheetsScopes = [
    'https://www.googleapis.com/auth/spreadsheets',
    'https://www.googleapis.com/auth/drive.file',
  ];
  
  // Local storage keys
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'app_theme';
  static const String sheetsAuthKey = 'sheets_auth';
  
  // Default calorie calculation formulas
  // Mifflin-St Jeor Equation
  static double calculateBMR(bool isMale, int age, double weightKg, double heightCm) {
    if (isMale) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }
  
  // Activity multipliers
  static const double sedentaryMultiplier = 1.2;
  static const double lightlyActiveMultiplier = 1.375;
  static const double moderatelyActiveMultiplier = 1.55;
  static const double veryActiveMultiplier = 1.725;
  static const double extraActiveMultiplier = 1.9;
  
  // Spreadsheet template IDs
  static const String workoutTemplateId = '';
  static const String nutritionTemplateId = '';
  static const String weightTrackingTemplateId = '';
  
  // Default rest periods (in seconds)
  static const int defaultRestBetweenSets = 90;
  static const int defaultRestBetweenExercises = 120;
  
  // Default exercise categories
  static const List<String> exerciseCategories = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Cardio',
    'Full Body',
    'Other'
  ];
  
  // Default macro distribution
  static const double defaultProteinPercentage = 0.30;
  static const double defaultCarbPercentage = 0.45;
  static const double defaultFatPercentage = 0.25;
  
  // Nutrition constants
  static const int caloriesPerGramProtein = 4;
  static const int caloriesPerGramCarb = 4;
  static const int caloriesPerGramFat = 9;
} 