import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/core/config/app_constants.dart';
import 'package:task_flow/core/utils/responsive_utils.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/domain/repositories/local_storage_repository.dart';
import 'package:task_flow/presentation/common/widgets/custom_app_bar.dart';
import 'package:task_flow/presentation/common/widgets/custom_button.dart';
import 'package:task_flow/presentation/profile/profile_viewmodel.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        authRepository: context.read<AuthRepository>(),
        localStorage: context.read<LocalStorageRepository>(),
      )..getUserEmail(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final userInitial = viewModel.userEmail.isNotEmpty
        ? viewModel.userEmail[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.paddingLarge),

              // Profile Avatar Section
              Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    userInitial,
                    style: TextStyle(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Email Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSmall,
                        ),
                      ),
                      child: const Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                        size: AppConstants.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            viewModel.userEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // App Version Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSmall,
                        ),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: AppColors.success,
                        size: AppConstants.iconMedium,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Version',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.paddingXLarge),
              // Logout Button
              CustomButton(
                text: 'Logout',
                onPressed: () => viewModel.logout(context),
                variant: ButtonVariant.danger,
              ),

              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
