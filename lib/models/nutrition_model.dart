class MealEntry {
  final String id;
  final String userId;
  final DateTime dateTime;
  final String mealType; // e.g., Breakfast, Lunch, Dinner, Snack
  final List<FoodItem> foodItems;
  final int totalCalories;
  final double totalProteinGrams;
  final double totalCarbsGrams;
  final double totalFatGrams;
  final String? notes;

  MealEntry({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.mealType,
    required this.foodItems,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.totalCarbsGrams,
    required this.totalFatGrams,
    this.notes,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      mealType: json['mealType'] as String,
      foodItems: (json['foodItems'] as List)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: json['totalCalories'] as int,
      totalProteinGrams: json['totalProteinGrams'] as double,
      totalCarbsGrams: json['totalCarbsGrams'] as double,
      totalFatGrams: json['totalFatGrams'] as double,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dateTime': dateTime.toIso8601String(),
      'mealType': mealType,
      'foodItems': foodItems.map((e) => e.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProteinGrams': totalProteinGrams,
      'totalCarbsGrams': totalCarbsGrams,
      'totalFatGrams': totalFatGrams,
      'notes': notes,
    };
  }

  MealEntry copyWith({
    String? id,
    String? userId,
    DateTime? dateTime,
    String? mealType,
    List<FoodItem>? foodItems,
    int? totalCalories,
    double? totalProteinGrams,
    double? totalCarbsGrams,
    double? totalFatGrams,
    String? notes,
  }) {
    return MealEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateTime: dateTime ?? this.dateTime,
      mealType: mealType ?? this.mealType,
      foodItems: foodItems ?? this.foodItems,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteinGrams: totalProteinGrams ?? this.totalProteinGrams,
      totalCarbsGrams: totalCarbsGrams ?? this.totalCarbsGrams,
      totalFatGrams: totalFatGrams ?? this.totalFatGrams,
      notes: notes ?? this.notes,
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final double servingSize;
  final String servingUnit;
  final int caloriesPerServing;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double quantity;
  final String? brand;
  final String? category;
  final Map<String, double>? micronutrients;

  FoodItem({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.servingUnit,
    required this.caloriesPerServing,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.quantity,
    this.brand,
    this.category,
    this.micronutrients,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      servingSize: json['servingSize'] as double,
      servingUnit: json['servingUnit'] as String,
      caloriesPerServing: json['caloriesPerServing'] as int,
      proteinGrams: json['proteinGrams'] as double,
      carbsGrams: json['carbsGrams'] as double,
      fatGrams: json['fatGrams'] as double,
      quantity: json['quantity'] as double,
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      micronutrients: json['micronutrients'] != null
          ? Map<String, double>.from(json['micronutrients'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'caloriesPerServing': caloriesPerServing,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'quantity': quantity,
      'brand': brand,
      'category': category,
      'micronutrients': micronutrients,
    };
  }

  int get totalCalories => (caloriesPerServing * quantity).round();
  double get totalProtein => proteinGrams * quantity;
  double get totalCarbs => carbsGrams * quantity;
  double get totalFat => fatGrams * quantity;

  FoodItem copyWith({
    String? id,
    String? name,
    double? servingSize,
    String? servingUnit,
    int? caloriesPerServing,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    double? quantity,
    String? brand,
    String? category,
    Map<String, double>? micronutrients,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      micronutrients: micronutrients ?? this.micronutrients,
    );
  }
}

class DailyNutritionSummary {
  final String id;
  final String userId;
  final DateTime date;
  final int targetCalories;
  final double targetProteinGrams;
  final double targetCarbsGrams;
  final double targetFatGrams;
  final int actualCalories;
  final double actualProteinGrams;
  final double actualCarbsGrams;
  final double actualFatGrams;
  final List<String> mealEntryIds;
  final int? caloriesBurnedFromExercise;
  final int? netCalories;
  final double? waterIntakeLiters;

  DailyNutritionSummary({
    required this.id,
    required this.userId,
    required this.date,
    required this.targetCalories,
    required this.targetProteinGrams,
    required this.targetCarbsGrams,
    required this.targetFatGrams,
    required this.actualCalories,
    required this.actualProteinGrams,
    required this.actualCarbsGrams,
    required this.actualFatGrams,
    required this.mealEntryIds,
    this.caloriesBurnedFromExercise,
    this.netCalories,
    this.waterIntakeLiters,
  });

  factory DailyNutritionSummary.fromJson(Map<String, dynamic> json) {
    return DailyNutritionSummary(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      targetCalories: json['targetCalories'] as int,
      targetProteinGrams: json['targetProteinGrams'] as double,
      targetCarbsGrams: json['targetCarbsGrams'] as double,
      targetFatGrams: json['targetFatGrams'] as double,
      actualCalories: json['actualCalories'] as int,
      actualProteinGrams: json['actualProteinGrams'] as double,
      actualCarbsGrams: json['actualCarbsGrams'] as double,
      actualFatGrams: json['actualFatGrams'] as double,
      mealEntryIds: List<String>.from(json['mealEntryIds'] as List),
      caloriesBurnedFromExercise: json['caloriesBurnedFromExercise'] as int?,
      netCalories: json['netCalories'] as int?,
      waterIntakeLiters: json['waterIntakeLiters'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'targetCalories': targetCalories,
      'targetProteinGrams': targetProteinGrams,
      'targetCarbsGrams': targetCarbsGrams,
      'targetFatGrams': targetFatGrams,
      'actualCalories': actualCalories,
      'actualProteinGrams': actualProteinGrams,
      'actualCarbsGrams': actualCarbsGrams,
      'actualFatGrams': actualFatGrams,
      'mealEntryIds': mealEntryIds,
      'caloriesBurnedFromExercise': caloriesBurnedFromExercise,
      'netCalories': netCalories,
      'waterIntakeLiters': waterIntakeLiters,
    };
  }

  double get proteinPercentage {
    return (actualProteinGrams * 4 / actualCalories) * 100;
  }

  double get carbsPercentage {
    return (actualCarbsGrams * 4 / actualCalories) * 100;
  }

  double get fatPercentage {
    return (actualFatGrams * 9 / actualCalories) * 100;
  }

  int get remainingCalories {
    return targetCalories - actualCalories + (caloriesBurnedFromExercise ?? 0);
  }

  DailyNutritionSummary copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? targetCalories,
    double? targetProteinGrams,
    double? targetCarbsGrams,
    double? targetFatGrams,
    int? actualCalories,
    double? actualProteinGrams,
    double? actualCarbsGrams,
    double? actualFatGrams,
    List<String>? mealEntryIds,
    int? caloriesBurnedFromExercise,
    int? netCalories,
    double? waterIntakeLiters,
  }) {
    return DailyNutritionSummary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProteinGrams: targetProteinGrams ?? this.targetProteinGrams,
      targetCarbsGrams: targetCarbsGrams ?? this.targetCarbsGrams,
      targetFatGrams: targetFatGrams ?? this.targetFatGrams,
      actualCalories: actualCalories ?? this.actualCalories,
      actualProteinGrams: actualProteinGrams ?? this.actualProteinGrams,
      actualCarbsGrams: actualCarbsGrams ?? this.actualCarbsGrams,
      actualFatGrams: actualFatGrams ?? this.actualFatGrams,
      mealEntryIds: mealEntryIds ?? this.mealEntryIds,
      caloriesBurnedFromExercise:
          caloriesBurnedFromExercise ?? this.caloriesBurnedFromExercise,
      netCalories: netCalories ?? this.netCalories,
      waterIntakeLiters: waterIntakeLiters ?? this.waterIntakeLiters,
    );
  }
}

class WeightEntry {
  final String id;
  final String userId;
  final DateTime date;
  final double weightKg;
  final double? bodyFatPercentage;
  final String? notes;

  WeightEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.weightKg,
    this.bodyFatPercentage,
    this.notes,
  });

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      weightKg: json['weightKg'] as double,
      bodyFatPercentage: json['bodyFatPercentage'] as double?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'weightKg': weightKg,
      'bodyFatPercentage': bodyFatPercentage,
      'notes': notes,
    };
  }

  WeightEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weightKg,
    double? bodyFatPercentage,
    String? notes,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      notes: notes ?? this.notes,
    );
  }
} 