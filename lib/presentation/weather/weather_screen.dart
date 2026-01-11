import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/core/config/app_constants.dart';
import 'package:task_flow/core/utils/responsive_utils.dart';
import 'package:task_flow/domain/repositories/weather_repository.dart';
import 'package:task_flow/presentation/common/widgets/custom_app_bar.dart';
import 'package:task_flow/presentation/common/widgets/loading_indicator.dart';
import 'package:task_flow/presentation/weather/weather_viewmodel.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherViewModel(
        weatherRepository: context.read<WeatherRepository>(),
      ),
      child: const _WeatherScreenContent(),
    );
  }
}

class _WeatherScreenContent extends StatefulWidget {
  const _WeatherScreenContent();

  @override
  State<_WeatherScreenContent> createState() => _WeatherScreenContentState();
}

class _WeatherScreenContentState extends State<_WeatherScreenContent> {
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Weather', showBackButton: false),
      body: viewModel.isLoading
          ? const LoadingIndicator(message: 'Loading...')
          : Stack(
              children: [
                // Animated background gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.background,
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: AppConstants.paddingMedium,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern Search Bar
                      _buildModernSearchBar(viewModel, screenWidth),

                      SizedBox(height: screenHeight * 0.03),

                      // Error State
                      if (viewModel.errorMessage != null)
                        _buildErrorCard(viewModel.errorMessage!)
                      // Weather Data
                      else if (viewModel.weather != null)
                        Column(
                          children: [
                            // Main Weather Card with Glassmorphism
                            _buildMainWeatherCard(
                              viewModel,
                              screenWidth,
                              screenHeight,
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            // Weather Details Grid
                            _buildWeatherDetailsGrid(viewModel, screenWidth),

                            SizedBox(height: screenHeight * 0.025),

                            // Refresh Button
                            _buildRefreshButton(viewModel, screenWidth),
                          ],
                        )
                      // Empty State
                      else
                        _buildEmptyState(screenHeight),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildModernSearchBar(WeatherViewModel viewModel, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.primary.withOpacity(0.7),
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  if (_cityController.text.isNotEmpty) {
                    viewModel.fetchWeather(_cityController.text);
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textWhite,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard(
    WeatherViewModel viewModel,
    double screenWidth,
    double screenHeight,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.all(screenWidth * 0.06),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primary.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // City Name
              Text(
                viewModel.weather!.cityName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Weather Description
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  viewModel.weather!.description.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textWhite,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Weather Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  viewModel.getWeatherIcon(),
                  size: 80,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${viewModel.weather!.temperature.round()}',
                    style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textWhite,
                      height: 0.9,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '°C',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Feels Like
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Feels like ${viewModel.weather!.feelsLike.round()}°C',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(
    WeatherViewModel viewModel,
    double screenWidth,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildModernInfoCard(
            icon: Icons.water_drop_outlined,
            label: 'Humidity',
            value: '${viewModel.weather!.humidity}%',
            gradient: [Colors.blue.shade400, Colors.blue.shade600],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildModernInfoCard(
            icon: Icons.air,
            label: 'Wind Speed',
            value: '${viewModel.weather!.windSpeed.toStringAsFixed(1)} m/s',
            gradient: [Colors.teal.shade400, Colors.teal.shade600],
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(WeatherViewModel viewModel, double screenWidth) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => viewModel.refreshWeather(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: screenWidth,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Refresh Weather',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade700,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 15,
                color: Colors.red.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * 0.1),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Search for a city',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a city name to see the weather',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
