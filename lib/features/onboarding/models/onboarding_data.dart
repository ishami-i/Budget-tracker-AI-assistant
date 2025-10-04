import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'onboarding_slide.dart';

/// Static data for onboarding slides
/// Contains the 4 slides matching the original React Native app design
class OnboardingData {
  /// List of all onboarding slides in order
  static const List<OnboardingSlide> slides = [
    // Slide 1: Income tracking
    OnboardingSlide(
      id: 1,
      title: 'Track Your Income',
      subtitle: 'Easily monitor and categorize all your income sources in one place',
      icon: Icons.account_balance_wallet,
      gradientColors: AppColors.gradientGreen,
    ),
    
    // Slide 2: AI Analysis
    OnboardingSlide(
      id: 2,
      title: 'AI-Powered Analysis',
      subtitle: 'Get intelligent insights and personalized recommendations for your spending habits',
      icon: Icons.psychology,
      gradientColors: AppColors.gradientBlue,
    ),
    
    // Slide 3: Savings
    OnboardingSlide(
      id: 3,
      title: 'Smart Savings',
      subtitle: 'Automatically identify opportunities to save money and reach your financial goals',
      icon: Icons.savings,
      gradientColors: AppColors.gradientPurple,
    ),
    
    // Slide 4: Flexibility
    OnboardingSlide(
      id: 4,
      title: 'Flexible Budgeting',
      subtitle: 'Adapt your budget to your lifestyle with customizable categories and limits',
      icon: Icons.tune,
      gradientColors: AppColors.gradientGreen,
    ),
  ];

  /// Get a specific slide by ID
  static OnboardingSlide? getSlideById(int id) {
    try {
      return slides.firstWhere((slide) => slide.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get the total number of slides
  static int get slideCount => slides.length;

  /// Check if a slide ID is valid
  static bool isValidSlideId(int id) {
    return id >= 1 && id <= slideCount;
  }

  /// Get the next slide ID (returns null if current is the last slide)
  static int? getNextSlideId(int currentId) {
    if (currentId < slideCount) {
      return currentId + 1;
    }
    return null;
  }

  /// Get the previous slide ID (returns null if current is the first slide)
  static int? getPreviousSlideId(int currentId) {
    if (currentId > 1) {
      return currentId - 1;
    }
    return null;
  }

  /// Check if the given slide is the last slide
  static bool isLastSlide(int slideId) {
    return slideId == slideCount;
  }

  /// Check if the given slide is the first slide
  static bool isFirstSlide(int slideId) {
    return slideId == 1;
  }
}