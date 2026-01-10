import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/presentation/common/widgets/custom_app_bar.dart';
import 'package:task_flow/presentation/common/widgets/loading_indicator.dart';
import 'package:task_flow/presentation/weather/weather_viewmodel.dart';

/// Weather screen
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(),
      child: const _WeatherScreenContent(),
    );
  }
}

class _WeatherScreenContent extends StatelessWidget {
  const _WeatherScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Weather', showBackButton: false),
      body: viewModel.isLoading
          ? const LoadingIndicator(message: 'Fetching weather data...')
          : viewModel.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                'Weather data will be displayed here',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ),
    );
  }
}
