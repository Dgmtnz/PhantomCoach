import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phantom_coach/config/theme.dart';
import 'package:phantom_coach/widgets/dashboard/dashboard_card.dart';
import 'package:phantom_coach/widgets/dashboard/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Temporary no-op
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/welcome');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // For development, just wait a moment
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome, Athlete',
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
                            child: _buildWorkoutStats(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildNutritionStats(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildWeightStats(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildWorkoutStats(),
                          const SizedBox(height: 16),
                          _buildNutritionStats(),
                          const SizedBox(height: 16),
                          _buildWeightStats(),
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
                                // For development, no action yet
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
                                // For development, no action yet
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DashboardCard(
                              title: 'Track Weight',
                              icon: Icons.monitor_weight,
                              color: AppTheme.accentColor,
                              onTap: () {
                                // For development, no action yet
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          DashboardCard(
                            title: 'Start Workout',
                            icon: Icons.fitness_center,
                            color: AppTheme.primaryColor,
                            onTap: () {
                              // For development, no action yet
                            },
                          ),
                          const SizedBox(height: 16),
                          DashboardCard(
                            title: 'Log Meal',
                            icon: Icons.restaurant,
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              // For development, no action yet
                            },
                          ),
                          const SizedBox(height: 16),
                          DashboardCard(
                            title: 'Track Weight',
                            icon: Icons.monitor_weight,
                            color: AppTheme.accentColor,
                            onTap: () {
                              // For development, no action yet
                            },
                          ),
                        ],
                      ),
                
                const SizedBox(height: 24),
                
                // Today's Schedule - Just a placeholder for now
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upper Body Workout',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '6:00 PM - 7:30 PM',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.notifications,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
        ],
        onTap: (index) {
          // For now, just a placeholder
        },
      ),
    );
  }

  Widget _buildWorkoutStats() {
    return StatCard(
      title: 'Workouts',
      value: '3',
      icon: Icons.fitness_center,
      color: AppTheme.primaryColor,
      onTap: () {
        // Placeholder - would navigate to workouts
      },
    );
  }

  Widget _buildNutritionStats() {
    return StatCard(
      title: 'Nutrition',
      value: '+540',
      icon: Icons.restaurant,
      color: AppTheme.secondaryColor,
      onTap: () {
        // Placeholder - would navigate to nutrition tracking
      },
    );
  }

  Widget _buildWeightStats() {
    return StatCard(
      title: 'Weight',
      value: '75.5 kg',
      icon: Icons.monitor_weight,
      color: AppTheme.accentColor,
      onTap: () {
        // Placeholder - would navigate to weight tracking
      },
    );
  }
} 