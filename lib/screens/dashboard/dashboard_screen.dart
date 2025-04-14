import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:phantom_coach/config/theme.dart';
import 'package:phantom_coach/providers/auth_provider.dart';
import 'package:phantom_coach/providers/workout_provider.dart';
import 'package:phantom_coach/providers/nutrition_provider.dart';
import 'package:phantom_coach/widgets/dashboard/dashboard_card.dart';
import 'package:phantom_coach/widgets/dashboard/stats_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load workout routines
      await Provider.of<WorkoutProvider>(context, listen: false).loadRoutines();

      // Load workout history
      await Provider.of<WorkoutProvider>(context, listen: false).loadWorkoutHistory();

      // Load meal entries
      await Provider.of<NutritionProvider>(context, listen: false).loadMealEntries();

      // Load weight entries
      await Provider.of<NutritionProvider>(context, listen: false).loadWeightEntries();

      // Load today's nutrition summary
      final userProfile = Provider.of<AuthProvider>(context, listen: false).currentUser?.profile;
      if (userProfile != null) {
        await Provider.of<NutritionProvider>(context, listen: false).loadTodaySummary(userProfile);
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final nutritionProvider = Provider.of<NutritionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await authProvider.signOut();
                if (mounted) {
                  context.go('/login');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error signing out: ${e.toString()}'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome message
                    Text(
                      'Welcome, ${user?.displayName ?? 'Athlete'}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Here\'s your fitness overview for today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Overview
                    isTabletOrDesktop 
                        ? Row(
                            children: [
                              Expanded(
                                child: _buildWorkoutStats(workoutProvider),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildNutritionStats(nutritionProvider),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildWeightStats(nutritionProvider),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildWorkoutStats(workoutProvider),
                              const SizedBox(height: 16),
                              _buildNutritionStats(nutritionProvider),
                              const SizedBox(height: 16),
                              _buildWeightStats(nutritionProvider),
                            ],
                          ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    isTabletOrDesktop
                        ? Row(
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  title: 'Start Workout',
                                  icon: Icons.fitness_center,
                                  color: AppTheme.primaryColor,
                                  onTap: () {
                                    context.go('/routines');
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DashboardCard(
                                  title: 'Log Meal',
                                  icon: Icons.restaurant,
                                  color: AppTheme.secondaryColor,
                                  onTap: () {
                                    context.go('/calories');
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DashboardCard(
                                  title: 'Log Weight',
                                  icon: Icons.monitor_weight,
                                  color: Colors.orange,
                                  onTap: () {
                                    context.go('/progress');
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DashboardCard(
                                  title: 'Create Routine',
                                  icon: Icons.add_chart,
                                  color: Colors.teal,
                                  onTap: () {
                                    context.go('/routine/create');
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Start Workout',
                                      icon: Icons.fitness_center,
                                      color: AppTheme.primaryColor,
                                      onTap: () {
                                        context.go('/routines');
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Log Meal',
                                      icon: Icons.restaurant,
                                      color: AppTheme.secondaryColor,
                                      onTap: () {
                                        context.go('/calories');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Log Weight',
                                      icon: Icons.monitor_weight,
                                      color: Colors.orange,
                                      onTap: () {
                                        context.go('/progress');
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Create Routine',
                                      icon: Icons.add_chart,
                                      color: Colors.teal,
                                      onTap: () {
                                        context.go('/routine/create');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildRecentActivity(workoutProvider, nutritionProvider),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWorkoutStats(WorkoutProvider workoutProvider) {
    final history = workoutProvider.workoutHistory;
    final thisWeekWorkouts = history.where((session) {
      final now = DateTime.now();
      final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
      return session.startTime.isAfter(startOfWeek);
    }).length;

    final lastWorkout = history.isNotEmpty ? history.first.formattedDate : 'No workouts yet';

    return StatsCard(
      title: 'Workouts',
      value: thisWeekWorkouts.toString(),
      label: 'This Week',
      secondaryValue: lastWorkout,
      secondaryLabel: 'Last Workout',
      icon: Icons.fitness_center,
      color: AppTheme.primaryColor,
    );
  }

  Widget _buildNutritionStats(NutritionProvider nutritionProvider) {
    final summary = nutritionProvider.todaySummary;
    final caloriesRemaining = summary?.remainingCalories ?? 0;
    final caloriesConsumed = summary?.actualCalories ?? 0;
    final targetCalories = summary?.targetCalories ?? 2000;
    
    return StatsCard(
      title: 'Nutrition',
      value: caloriesRemaining > 0 ? '+$caloriesRemaining' : '$caloriesRemaining',
      label: 'Calories Remaining',
      secondaryValue: '$caloriesConsumed/$targetCalories',
      secondaryLabel: 'Calories Consumed',
      icon: Icons.restaurant,
      color: AppTheme.secondaryColor,
    );
  }

  Widget _buildWeightStats(NutritionProvider nutritionProvider) {
    final weightEntries = nutritionProvider.weightEntries;
    final currentWeight = weightEntries.isNotEmpty ? '${weightEntries.first.weightKg} kg' : 'No data';
    
    // Calculate weight change
    String weightChange = 'No data';
    if (weightEntries.length >= 2) {
      final latestWeight = weightEntries.first.weightKg;
      final previousWeight = weightEntries.last.weightKg;
      final difference = latestWeight - previousWeight;
      weightChange = difference >= 0 ? '+${difference.toStringAsFixed(1)} kg' : '${difference.toStringAsFixed(1)} kg';
    }
    
    return StatsCard(
      title: 'Weight',
      value: currentWeight,
      label: 'Current',
      secondaryValue: weightChange,
      secondaryLabel: 'Change',
      icon: Icons.monitor_weight,
      color: Colors.orange,
    );
  }

  Widget _buildRecentActivity(WorkoutProvider workoutProvider, NutritionProvider nutritionProvider) {
    final workoutHistory = workoutProvider.workoutHistory;
    final mealEntries = nutritionProvider.mealEntries;
    
    // Combine and sort both types of activities
    final recentActivities = <Map<String, dynamic>>[];
    
    // Add workouts
    for (final workout in workoutHistory) {
      recentActivities.add({
        'type': 'workout',
        'dateTime': workout.startTime,
        'title': 'Completed a workout',
        'details': '${workout.formattedDate} (${workout.duration})',
      });
    }
    
    // Add meals
    for (final meal in mealEntries) {
      recentActivities.add({
        'type': 'meal',
        'dateTime': meal.dateTime,
        'title': 'Logged a ${meal.mealType.toLowerCase()}',
        'details': '${meal.totalCalories} cal, ${meal.foodItems.length} items',
      });
    }
    
    // Sort by date, most recent first
    recentActivities.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));
    
    // Take only the 5 most recent activities
    final recentFive = recentActivities.take(5).toList();
    
    if (recentFive.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No recent activity. Start tracking your fitness journey!'),
          ),
        ),
      );
    }
    
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentFive.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final activity = recentFive[index];
          final bool isWorkout = activity['type'] == 'workout';
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isWorkout ? AppTheme.primaryColor : AppTheme.secondaryColor,
              child: Icon(
                isWorkout ? Icons.fitness_center : Icons.restaurant,
                color: Colors.white,
              ),
            ),
            title: Text(activity['title']),
            subtitle: Text(activity['details']),
            trailing: isWorkout
                ? TextButton(
                    onPressed: () {
                      // View workout details
                    },
                    child: const Text('View'),
                  )
                : null,
          );
        },
      ),
    );
  }
} 