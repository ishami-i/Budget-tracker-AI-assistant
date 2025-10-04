import 'package:flutter/material.dart';
import '../../../shared/widgets/glass_button.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// Controls widget for onboarding screen
/// 
/// Features:
/// - Skip button with glassmorphism styling
/// - Get Started button on final slide with gradient background
/// - Proper spacing and responsive layout
/// - Smooth transitions between states
class OnboardingControls extends StatelessWidget {
  /// Current slide index
  final int currentIndex;
  
  /// Total number of slides
  final int totalSlides;
  
  /// Callback when skip button is tapped
  final VoidCallback? onSkip;
  
  /// Callback when get started button is tapped
  final VoidCallback? onGetStarted;
  
  const OnboardingControls({
    super.key,
    required this.currentIndex,
    required this.totalSlides,
    this.onSkip,
    this.onGetStarted,
  });

  bool get isLastSlide => currentIndex == totalSlides - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button (hidden on last slide)
          AnimatedOpacity(
            opacity: isLastSlide ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: _buildSkipButton(),
          ),
          
          // Get Started button (only visible on last slide)
          AnimatedOpacity(
            opacity: isLastSlide ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _buildGetStartedButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: isLastSlide ? null : onSkip,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassInput,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.glassBorderInput,
            width: 1,
          ),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return GlassButton(
      text: 'Get Started',
      onPressed: isLastSlide ? onGetStarted : null,
      gradientColors: AppColors.gradientGreen,
      icon: const Icon(
        Icons.arrow_forward,
        color: AppColors.text,
        size: 20,
      ),
    );
  }
}