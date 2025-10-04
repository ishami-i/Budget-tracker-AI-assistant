import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// Custom pagination dots widget for onboarding slides
/// 
/// Features:
/// - Glassmorphism styling for active and inactive states
/// - Smooth animations between states
/// - Tap handling for manual navigation
/// - Responsive sizing
class OnboardingPagination extends StatelessWidget {
  /// Current active slide index
  final int currentIndex;
  
  /// Total number of slides
  final int totalSlides;
  
  /// Callback when a dot is tapped
  final void Function(int index)? onDotTapped;
  
  const OnboardingPagination({
    super.key,
    required this.currentIndex,
    required this.totalSlides,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalSlides,
          (index) => _buildPaginationDot(index),
        ),
      ),
    );
  }

  Widget _buildPaginationDot(int index) {
    final isActive = index == currentIndex;
    
    return GestureDetector(
      onTap: () => onDotTapped?.call(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingSmall,
        ),
        width: isActive ? 24 : 12,
        height: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isActive 
            ? AppColors.glassButton
            : AppColors.glassInput,
          border: Border.all(
            color: isActive 
              ? AppColors.glassBorderButton
              : AppColors.glassBorderInput,
            width: 1,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.neonGreenGlow.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ] : null,
        ),
        child: isActive ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.gradientGreen,
            ),
          ),
        ) : null,
      ),
    );
  }
}