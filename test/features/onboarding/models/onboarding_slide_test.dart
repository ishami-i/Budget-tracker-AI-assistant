import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/onboarding/models/onboarding_slide.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';

void main() {
  group('OnboardingSlide', () {
    test('should create OnboardingSlide with all required properties', () {
      // Arrange
      const slide = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      // Assert
      expect(slide.id, equals(1));
      expect(slide.title, equals('Test Title'));
      expect(slide.subtitle, equals('Test Subtitle'));
      expect(slide.icon, equals(Icons.star));
      expect(slide.gradientColors, equals(AppColors.gradientGreen));
    });

    test('should support equality comparison', () {
      // Arrange
      const slide1 = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      const slide2 = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      const slide3 = OnboardingSlide(
        id: 2,
        title: 'Different Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      // Assert
      expect(slide1, equals(slide2));
      expect(slide1, isNot(equals(slide3)));
    });

    test('should have consistent hashCode for equal objects', () {
      // Arrange
      const slide1 = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      const slide2 = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      // Assert
      expect(slide1.hashCode, equals(slide2.hashCode));
    });

    test('should provide meaningful toString representation', () {
      // Arrange
      const slide = OnboardingSlide(
        id: 1,
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: Icons.star,
        gradientColors: AppColors.gradientGreen,
      );

      // Act
      final stringRepresentation = slide.toString();

      // Assert
      expect(stringRepresentation, contains('OnboardingSlide'));
      expect(stringRepresentation, contains('id: 1'));
      expect(stringRepresentation, contains('title: Test Title'));
      expect(stringRepresentation, contains('subtitle: Test Subtitle'));
    });

    test('should handle gradient colors list comparison correctly', () {
      // Arrange
      const slide1 = OnboardingSlide(
        id: 1,
        title: 'Test',
        subtitle: 'Test',
        icon: Icons.star,
        gradientColors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      );

      const slide2 = OnboardingSlide(
        id: 1,
        title: 'Test',
        subtitle: 'Test',
        icon: Icons.star,
        gradientColors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      );

      const slide3 = OnboardingSlide(
        id: 1,
        title: 'Test',
        subtitle: 'Test',
        icon: Icons.star,
        gradientColors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
      );

      // Assert
      expect(slide1, equals(slide2));
      expect(slide1, isNot(equals(slide3)));
    });
  });
}