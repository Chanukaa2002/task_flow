import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/core/config/app_constants.dart';
import 'package:task_flow/core/utils/date_utils.dart';
import 'package:task_flow/core/utils/responsive_utils.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';
import 'package:task_flow/domain/repositories/task_repository.dart';
import 'package:task_flow/presentation/common/widgets/bottom_nav_bar.dart';
import 'package:task_flow/presentation/home/home_viewmodel.dart';
import 'package:task_flow/presentation/home/widgets/task_list_item.dart';
import 'package:task_flow/presentation/profile/profile_screen.dart';
import 'package:task_flow/presentation/weather/weather_screen.dart';

/// Home screen with task list
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        taskRepository: context.read<TaskRepository>(),
        authRepository: context.read<AuthRepository>(),
        localStorage: context.read<LocalStorageRepository>(),
      ),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _TaskListView(),
    ProfileScreen(),
    WeatherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final screenWidth = ResponsiveUtils.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: const Icon(
                Icons.list_alt,
                color: AppColors.textWhite,
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => viewModel.navigateToAddTask(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last App Open
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              color: AppColors.surface,
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    'Last App Open',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    viewModel.lastAppOpen != null
                        ? DateTimeUtils.formatDateTime(viewModel.lastAppOpen!)
                        : 'N/A',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Upcoming Tasks Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              child: const Text(
                'Upcoming Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            // Upcoming Tasks List
            if (viewModel.upcomingTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppConstants.paddingLarge),
                child: Center(
                  child: Text(
                    'No upcoming tasks',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...viewModel.upcomingTasks.map(
                (task) => TaskListItem(
                  task: task,
                  onToggle: () => viewModel.toggleTaskComplete(task.id),
                  onTap: () => viewModel.navigateToEditTask(context, task),
                  onDelete: () => viewModel.deleteTask(task.id),
                ),
              ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Completed Tasks Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
              ),
              child: const Text(
                'Completed Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            // Completed Tasks List
            if (viewModel.completedTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppConstants.paddingLarge),
                child: Center(
                  child: Text(
                    'No completed tasks',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ...viewModel.completedTasks.map(
                (task) => TaskListItem(
                  task: task,
                  onToggle: () => viewModel.toggleTaskComplete(task.id),
                  onTap: () => viewModel.navigateToEditTask(context, task),
                  onDelete: () => viewModel.deleteTask(task.id),
                ),
              ),

            const SizedBox(height: AppConstants.paddingXLarge),
          ],
        ),
      ),
    );
  }
}
