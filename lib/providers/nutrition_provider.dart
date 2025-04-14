import 'package:flutter/foundation.dart';
import 'package:phantom_coach/models/nutrition_model.dart';
import 'package:phantom_coach/models/user_model.dart';
import 'package:phantom_coach/services/sheets_service.dart';
import 'package:phantom_coach/config/app_config.dart';

class NutritionProvider with ChangeNotifier {
  final SheetsService _sheetsService;
  
  List<MealEntry> _mealEntries = [];
  List<FoodItem> _recentFoodItems = [];
  List<WeightEntry> _weightEntries = [];
  DailyNutritionSummary? _todaySummary;
  bool _isLoading = false;
  String? _error;
  
  // Constructor
  NutritionProvider(this._sheetsService);
  
  // Getters
  List<MealEntry> get mealEntries => _mealEntries;
  List<FoodItem> get recentFoodItems => _recentFoodItems;
  List<WeightEntry> get weightEntries => _weightEntries;
  DailyNutritionSummary? get todaySummary => _todaySummary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Load today's nutrition summary
  Future<void> loadTodaySummary(UserProfile userProfile) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Create default nutrition targets based on user profile
      final targets = _calculateNutritionTargets(userProfile);
      
      // Load meals for today
      final today = DateTime.now();
      final todayMeals = _mealEntries.where((meal) => 
        meal.dateTime.year == today.year && 
        meal.dateTime.month == today.month && 
        meal.dateTime.day == today.day
      ).toList();
      
      // Calculate totals
      int actualCalories = 0;
      double actualProtein = 0;
      double actualCarbs = 0;
      double actualFat = 0;
      
      for (final meal in todayMeals) {
        actualCalories += meal.totalCalories;
        actualProtein += meal.totalProteinGrams;
        actualCarbs += meal.totalCarbsGrams;
        actualFat += meal.totalFatGrams;
      }
      
      // Create summary
      _todaySummary = DailyNutritionSummary(
        id: 'dns_${today.millisecondsSinceEpoch}',
        userId: 'current_user', // Replace with actual user ID
        date: today,
        targetCalories: targets['calories']!,
        targetProteinGrams: targets['protein']!,
        targetCarbsGrams: targets['carbs']!,
        targetFatGrams: targets['fat']!,
        actualCalories: actualCalories,
        actualProteinGrams: actualProtein,
        actualCarbsGrams: actualCarbs,
        actualFatGrams: actualFat,
        mealEntryIds: todayMeals.map((m) => m.id).toList(),
      );
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Load meal entries
  Future<void> loadMealEntries() async {
    try {
      _setLoading(true);
      _clearError();
      
      // In a real app, you would fetch meal entries from the backend or database
      // For now, let's just use a sample list
      _mealEntries = _createSampleMealEntries();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Load weight entries
  Future<void> loadWeightEntries() async {
    try {
      _setLoading(true);
      _clearError();
      
      // In a real app, you would fetch weight entries from the backend or database
      // For now, let's just use a sample list
      _weightEntries = _createSampleWeightEntries();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  // Add meal entry
  Future<void> addMealEntry(MealEntry mealEntry, String spreadsheetId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Add to local list
      _mealEntries.add(mealEntry);
      
      // Update today's summary if the meal is from today
      final today = DateTime.now();
      if (mealEntry.dateTime.year == today.year && 
          mealEntry.dateTime.month == today.month && 
          mealEntry.dateTime.day == today.day) {
        if (_todaySummary != null) {
          _todaySummary = _todaySummary!.copyWith(
            actualCalories: _todaySummary!.actualCalories + mealEntry.totalCalories,
            actualProteinGrams: _todaySummary!.actualProteinGrams + mealEntry.totalProteinGrams,
            actualCarbsGrams: _todaySummary!.actualCarbsGrams + mealEntry.totalCarbsGrams,
            actualFatGrams: _todaySummary!.actualFatGrams + mealEntry.totalFatGrams,
            mealEntryIds: [..._todaySummary!.mealEntryIds, mealEntry.id],
          );
        }
      }
      
      // Add any new food items to recent list
      for (final foodItem in mealEntry.foodItems) {
        if (!_recentFoodItems.any((item) => item.id == foodItem.id)) {
          _recentFoodItems.add(foodItem);
        }
      }
      
      // Save to Google Sheets
      try {
        // TODO: Save to Google Sheets
        // await _sheetsService.saveMealEntry(spreadsheetId, mealEntry);
      } catch (e) {
        print('Error saving meal entry to Google Sheets: $e');
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }
  
  // Add weight entry
  Future<void> addWeightEntry(WeightEntry weightEntry, String spreadsheetId) async {
    try {
      _setLoading(true);
      _clearError();
      
      // Add to local list
      _weightEntries.add(weightEntry);
      
      // Save to Google Sheets
      try {
        // TODO: Save to Google Sheets
        // await _sheetsService.saveWeightEntry(spreadsheetId, weightEntry);
      } catch (e) {
        print('Error saving weight entry to Google Sheets: $e');
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      rethrow;
    }
  }
  
  // Calculate BMI
  double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
  
  // Get BMI category
  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal weight';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
  
  // Calculate nutrition targets based on user profile
  Map<String, int> _calculateNutritionTargets(UserProfile profile) {
    // Default values if profile is incomplete
    int targetCalories = 2000;
    double proteinPercentage = AppConfig.defaultProteinPercentage;
    double carbsPercentage = AppConfig.defaultCarbPercentage;
    double fatPercentage = AppConfig.defaultFatPercentage;
    
    // Calculate BMR if profile has necessary data
    if (profile.age != null && profile.heightCm != null && profile.weightKg != null && profile.gender != null) {
      final isMale = profile.gender!.toLowerCase() == 'male';
      final bmr = AppConfig.calculateBMR(
        isMale, 
        profile.age!, 
        profile.weightKg!, 
        profile.heightCm!,
      );
      
      // Apply activity multiplier
      double activityMultiplier = AppConfig.sedentaryMultiplier;
      if (profile.activityLevel != null) {
        switch (profile.activityLevel!.toLowerCase()) {
          case 'lightly active':
            activityMultiplier = AppConfig.lightlyActiveMultiplier;
            break;
          case 'moderately active':
            activityMultiplier = AppConfig.moderatelyActiveMultiplier;
            break;
          case 'very active':
            activityMultiplier = AppConfig.veryActiveMultiplier;
            break;
          case 'extra active':
            activityMultiplier = AppConfig.extraActiveMultiplier;
            break;
        }
      }
      
      targetCalories = (bmr * activityMultiplier).round();
      
      // Adjust based on goal
      if (profile.fitnessGoal != null) {
        switch (profile.fitnessGoal!.toLowerCase()) {
          case 'lose weight':
            targetCalories = (targetCalories * 0.8).round();
            proteinPercentage = 0.40; // Higher protein for muscle preservation
            carbsPercentage = 0.35;
            fatPercentage = 0.25;
            break;
          case 'maintain weight':
            // No adjustment needed
            break;
          case 'gain weight':
          case 'build muscle':
            targetCalories = (targetCalories * 1.15).round();
            proteinPercentage = 0.35;
            carbsPercentage = 0.45;
            fatPercentage = 0.20;
            break;
        }
      }
    }
    
    // Calculate macros in grams
    final proteinGrams = (targetCalories * proteinPercentage / AppConfig.caloriesPerGramProtein).round();
    final carbGrams = (targetCalories * carbsPercentage / AppConfig.caloriesPerGramCarb).round();
    final fatGrams = (targetCalories * fatPercentage / AppConfig.caloriesPerGramFat).round();
    
    return {
      'calories': targetCalories,
      'protein': proteinGrams,
      'carbs': carbGrams,
      'fat': fatGrams,
    };
  }
  
  // Create sample meal entries
  List<MealEntry> _createSampleMealEntries() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    return [
      MealEntry(
        id: 'meal_1',
        userId: 'current_user',
        dateTime: DateTime(now.year, now.month, now.day, 8, 0),
        mealType: 'Breakfast',
        foodItems: [
          FoodItem(
            id: 'food_1',
            name: 'Oatmeal',
            servingSize: 100,
            servingUnit: 'g',
            caloriesPerServing: 350,
            proteinGrams: 10,
            carbsGrams: 60,
            fatGrams: 5,
            quantity: 1,
            category: 'Grains',
          ),
          FoodItem(
            id: 'food_2',
            name: 'Banana',
            servingSize: 1,
            servingUnit: 'medium',
            caloriesPerServing: 105,
            proteinGrams: 1.3,
            carbsGrams: 27,
            fatGrams: 0.4,
            quantity: 1,
            category: 'Fruits',
          ),
        ],
        totalCalories: 455,
        totalProteinGrams: 11.3,
        totalCarbsGrams: 87,
        totalFatGrams: 5.4,
      ),
      MealEntry(
        id: 'meal_2',
        userId: 'current_user',
        dateTime: DateTime(now.year, now.month, now.day, 12, 30),
        mealType: 'Lunch',
        foodItems: [
          FoodItem(
            id: 'food_3',
            name: 'Chicken Breast',
            servingSize: 150,
            servingUnit: 'g',
            caloriesPerServing: 250,
            proteinGrams: 48,
            carbsGrams: 0,
            fatGrams: 5.5,
            quantity: 1,
            category: 'Protein',
          ),
          FoodItem(
            id: 'food_4',
            name: 'Brown Rice',
            servingSize: 100,
            servingUnit: 'g',
            caloriesPerServing: 135,
            proteinGrams: 3,
            carbsGrams: 28,
            fatGrams: 1,
            quantity: 1.5,
            category: 'Grains',
          ),
          FoodItem(
            id: 'food_5',
            name: 'Broccoli',
            servingSize: 100,
            servingUnit: 'g',
            caloriesPerServing: 35,
            proteinGrams: 2.5,
            carbsGrams: 7,
            fatGrams: 0.5,
            quantity: 1,
            category: 'Vegetables',
          ),
        ],
        totalCalories: 487.5,
        totalProteinGrams: 54,
        totalCarbsGrams: 49,
        totalFatGrams: 8,
      ),
      MealEntry(
        id: 'meal_3',
        userId: 'current_user',
        dateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 18, 0),
        mealType: 'Dinner',
        foodItems: [
          FoodItem(
            id: 'food_6',
            name: 'Salmon Fillet',
            servingSize: 150,
            servingUnit: 'g',
            caloriesPerServing: 280,
            proteinGrams: 30,
            carbsGrams: 0,
            fatGrams: 18,
            quantity: 1,
            category: 'Protein',
          ),
          FoodItem(
            id: 'food_7',
            name: 'Sweet Potato',
            servingSize: 150,
            servingUnit: 'g',
            caloriesPerServing: 150,
            proteinGrams: 2,
            carbsGrams: 35,
            fatGrams: 0.1,
            quantity: 1,
            category: 'Vegetables',
          ),
          FoodItem(
            id: 'food_8',
            name: 'Mixed Salad',
            servingSize: 100,
            servingUnit: 'g',
            caloriesPerServing: 25,
            proteinGrams: 1,
            carbsGrams: 5,
            fatGrams: 0.2,
            quantity: 1,
            category: 'Vegetables',
          ),
        ],
        totalCalories: 455,
        totalProteinGrams: 33,
        totalCarbsGrams: 40,
        totalFatGrams: 18.3,
      ),
    ];
  }
  
  // Create sample weight entries
  List<WeightEntry> _createSampleWeightEntries() {
    final now = DateTime.now();
    
    return [
      WeightEntry(
        id: 'weight_1',
        userId: 'current_user',
        date: DateTime(now.year, now.month, now.day - 7),
        weightKg: 80.5,
        bodyFatPercentage: 18.2,
      ),
      WeightEntry(
        id: 'weight_2',
        userId: 'current_user',
        date: DateTime(now.year, now.month, now.day - 5),
        weightKg: 80.2,
        bodyFatPercentage: 18.0,
      ),
      WeightEntry(
        id: 'weight_3',
        userId: 'current_user',
        date: DateTime(now.year, now.month, now.day - 3),
        weightKg: 79.8,
        bodyFatPercentage: 17.8,
      ),
      WeightEntry(
        id: 'weight_4',
        userId: 'current_user',
        date: DateTime(now.year, now.month, now.day - 1),
        weightKg: 79.5,
        bodyFatPercentage: 17.7,
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
} 