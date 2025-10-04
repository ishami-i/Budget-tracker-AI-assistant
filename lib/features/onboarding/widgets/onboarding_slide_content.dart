import 'package:flutter/material.dart';
import '../../../shared/widgets/floating_3d.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../models/onboarding_slide.dart';

/// Widget that displays the content of an individual onboarding slide
/// 
/// Features:
/// - Floating 3D icon animation
/// - Gradient background for icon
/// - Title and subtitle text with proper styling
/// - Responsive layout for different screen sizes
class OnboardingSlideContent extends StatefulWidget {
  /// The slide data to display
  final OnboardingSlide slide;
  
  /// Whether this slide is currently active (for animations)
  final bool isActive;
  
  const OnboardingSlideContent({
    super.key,
    required this.slide,
    required this.isActive,
  });

  @override
  State<OnboardingSlideContent> createState() => _OnboardingSlideContentState();
}

class _OnboardingSlideContentState extends State<OnboardingSlideContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation if this slide is active
    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(OnboardingSlideContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger animation when slide becomes active
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Feature icon with floating animation
                  _buildFeatureIcon(),
                  
                  const SizedBox(height: AppDimensions.spacingXLarge),
                  
                  // Title
                  _buildTitle(),
                  
                  const SizedBox(height: AppDimensions.spacingMedium),
                  
                  // Subtitle
                  _buildSubtitle(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureIcon() {
    return Floating3D(
      intensity: 12.0,
      duration: const Duration(seconds: 3),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.slide.gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.slide.gradientColors.first.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: widget.slide.gradientColors.first.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Icon(
          widget.slide.icon,
          color: AppColors.text,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.slide.title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Text(
        widget.slide.subtitle,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}