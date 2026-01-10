import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/core/config/app_constants.dart';
import 'package:task_flow/core/utils/responsive_utils.dart';
import 'package:task_flow/presentation/common/widgets/custom_app_bar.dart';
import 'package:task_flow/presentation/common/widgets/custom_button.dart';
import 'package:task_flow/presentation/profile/profile_viewmodel.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..getUserEmail(),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: AppConstants.paddingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Address Section
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                viewModel.userEmail,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Logout Button
            CustomButton(
              text: 'Logout',
              onPressed: () => viewModel.logout(context),
              variant: ButtonVariant.danger,
            ),
          ],
        ),
      ),
    );
  }
}
