import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/glass_background.dart';
import '../../../shared/widgets/floating_3d.dart';
import '../../../shared/services/app_state_model.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../models/onboarding_data.dart';
import '../../../app/routes.dart';

import '../widgets/onboarding_slide_content.dart';
import '../widgets/onboarding_pagination.dart';
import '../widgets/onboarding_controls.dart';

/// Onboarding screen with slide navigation and auto-progression
///
/// Features:
/// - Horizontal slide navigation using PageView
/// - Auto-progression timer with 4-second intervals
/// - Manual navigation with PageController
/// - Floating 3D logo and animations
/// - Glassmorphism design matching original app
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late Timer _autoProgressTimer;
  Timer? _resumeTimer;
  int _currentSlideIndex = 0;
  bool _isAutoProgressing = true;

  // Animation controllers for the floating logo
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _startAutoProgression();
  }

  void _initializeControllers() {
    _pageController = PageController(initialPage: 0);

    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start logo animation
    _logoAnimationController.forward();
  }

  void _startAutoProgression() {
    _autoProgressTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isAutoProgressing && mounted) {
        _goToNextSlide();
      }
    });
  }

  void _stopAutoProgression() {
    _isAutoProgressing = false;
    if (_autoProgressTimer.isActive) {
      _autoProgressTimer.cancel();
    }
  }

  void _resumeAutoProgression() {
    if (!_isAutoProgressing) {
      _isAutoProgressing = true;
      _startAutoProgression();
    }
  }

  void _goToNextSlide() {
    if (_currentSlideIndex < OnboardingData.slideCount - 1) {
      _navigateToSlide(_currentSlideIndex + 1);
    } else {
      // Reached the end, complete onboarding
      _completeOnboarding();
    }
  }

  void _navigateToSlide(int index) {
    if (index >= 0 && index < OnboardingData.slideCount) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSlideChanged(int index) {
    setState(() {
      _currentSlideIndex = index;
    });
  }

  void _onManualNavigation() {
    // Stop auto-progression when user manually navigates
    _stopAutoProgression();

    // Cancel any existing resume timer
    _resumeTimer?.cancel();

    // Resume auto-progression after a delay
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        _resumeAutoProgression();
      }
    });
  }

  void _skipOnboarding() {
    _stopAutoProgression();
    _resumeTimer?.cancel();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    _stopAutoProgression();
    _resumeTimer?.cancel();
    final appState = Provider.of<AppStateModel>(context, listen: false);
    appState.completeOnboarding();

    // Navigate to sign-in screen
    NavigationService.pushReplacementNamed(AppRoutes.signIn);
  }

  @override
  void dispose() {
    _stopAutoProgression();
    _resumeTimer?.cancel();
    _pageController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with floating logo
              _buildHeader(),

              // Main slide content
              Expanded(child: _buildSlideContent()),

              // Pagination dots
              _buildPagination(),

              // Controls (Skip button / Get Started button)
              _buildControls(),

              // Bottom spacing
              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return RepaintBoundary(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Center(
          child: AnimatedBuilder(
            animation: _logoScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: const Floating3D(
                  intensity: 8.0,
                  duration: Duration(seconds: 4),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.gradientGreen,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonGreenGlow,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.text,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSlideContent() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        _onSlideChanged(index);
        _onManualNavigation();
      },
      itemCount: OnboardingData.slideCount,
      itemBuilder: (context, index) {
        final slide = OnboardingData.slides[index];
        return OnboardingSlideContent(
          slide: slide,
          isActive: index == _currentSlideIndex,
        );
      },
    );
  }

  Widget _buildPagination() {
    return OnboardingPagination(
      currentIndex: _currentSlideIndex,
      totalSlides: OnboardingData.slideCount,
      onDotTapped: (index) {
        _navigateToSlide(index);
        _onManualNavigation();
      },
    );
  }

  Widget _buildControls() {
    return OnboardingControls(
      currentIndex: _currentSlideIndex,
      totalSlides: OnboardingData.slideCount,
      onSkip: _skipOnboarding,
      onGetStarted: _completeOnboarding,
    );
  }
}
