import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/onboarding/models/onboarding_data.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';

void main() {
  group('OnboardingData', () {
    test('should have exactly 4 slides', () {
      // Assert
      expect(OnboardingData.slides.length, equals(4));
      expect(OnboardingData.slideCount, equals(4));
    });

    test('should have slides with sequential IDs starting from 1', () {
      // Assert
      for (int i = 0; i < OnboardingData.slides.length; i++) {
        expect(OnboardingData.slides[i].id, equals(i + 1));
      }
    });

    test('should have all slides with required properties', () {
      // Assert
      for (final slide in OnboardingData.slides) {
        expect(slide.id, isA<int>());
        expect(slide.title, isA<String>());
        expect(slide.subtitle, isA<String>());
        expect(slide.icon, isA<IconData>());
        expect(slide.gradientColors, isA<List<Color>>());
        
        // Ensure no empty strings
        expect(slide.title.trim(), isNotEmpty);
        expect(slide.subtitle.trim(), isNotEmpty);
        
        // Ensure gradient has at least 2 colors
        expect(slide.gradientColors.length, greaterThanOrEqualTo(2));
      }
    });

    test('should have correct slide content for income tracking (slide 1)', () {
      // Arrange
      final slide = OnboardingData.slides[0];

      // Assert
      expect(slide.id, equals(1));
      expect(slide.title, equals('Track Your Income'));
      expect(slide.subtitle, contains('income'));
      expect(slide.icon, equals(Icons.account_balance_wallet));
      expect(slide.gradientColors, equals(AppColors.gradientGreen));
    });

    test('should have correct slide content for AI analysis (slide 2)', () {
      // Arrange
      final slide = OnboardingData.slides[1];

      // Assert
      expect(slide.id, equals(2));
      expect(slide.title, equals('AI-Powered Analysis'));
      expect(slide.subtitle.toLowerCase(), anyOf(contains('ai'), contains('intelligent')));
      expect(slide.icon, equals(Icons.psychology));
      expect(slide.gradientColors, equals(AppColors.gradientBlue));
    });

    test('should have correct slide content for savings (slide 3)', () {
      // Arrange
      final slide = OnboardingData.slides[2];

      // Assert
      expect(slide.id, equals(3));
      expect(slide.title, equals('Smart Savings'));
      expect(slide.subtitle.toLowerCase(), anyOf(contains('save'), contains('savings')));
      expect(slide.icon, equals(Icons.savings));
      expect(slide.gradientColors, equals(AppColors.gradientPurple));
    });

    test('should have correct slide content for flexibility (slide 4)', () {
      // Arrange
      final slide = OnboardingData.slides[3];

      // Assert
      expect(slide.id, equals(4));
      expect(slide.title, equals('Flexible Budgeting'));
      expect(slide.subtitle.toLowerCase(), anyOf(contains('budget'), contains('flexible')));
      expect(slide.icon, equals(Icons.tune));
      expect(slide.gradientColors, equals(AppColors.gradientGreen));
    });

    test('should get slide by ID correctly', () {
      // Act & Assert
      final slide1 = OnboardingData.getSlideById(1);
      final slide2 = OnboardingData.getSlideById(2);
      final slide3 = OnboardingData.getSlideById(3);
      final slide4 = OnboardingData.getSlideById(4);
      final invalidSlide = OnboardingData.getSlideById(5);

      expect(slide1?.id, equals(1));
      expect(slide2?.id, equals(2));
      expect(slide3?.id, equals(3));
      expect(slide4?.id, equals(4));
      expect(invalidSlide, isNull);
    });

    test('should validate slide IDs correctly', () {
      // Assert
      expect(OnboardingData.isValidSlideId(1), isTrue);
      expect(OnboardingData.isValidSlideId(2), isTrue);
      expect(OnboardingData.isValidSlideId(3), isTrue);
      expect(OnboardingData.isValidSlideId(4), isTrue);
      expect(OnboardingData.isValidSlideId(0), isFalse);
      expect(OnboardingData.isValidSlideId(5), isFalse);
      expect(OnboardingData.isValidSlideId(-1), isFalse);
    });

    test('should get next slide ID correctly', () {
      // Assert
      expect(OnboardingData.getNextSlideId(1), equals(2));
      expect(OnboardingData.getNextSlideId(2), equals(3));
      expect(OnboardingData.getNextSlideId(3), equals(4));
      expect(OnboardingData.getNextSlideId(4), isNull); // Last slide
    });

    test('should get previous slide ID correctly', () {
      // Assert
      expect(OnboardingData.getPreviousSlideId(1), isNull); // First slide
      expect(OnboardingData.getPreviousSlideId(2), equals(1));
      expect(OnboardingData.getPreviousSlideId(3), equals(2));
      expect(OnboardingData.getPreviousSlideId(4), equals(3));
    });

    test('should identify first and last slides correctly', () {
      // Assert
      expect(OnboardingData.isFirstSlide(1), isTrue);
      expect(OnboardingData.isFirstSlide(2), isFalse);
      expect(OnboardingData.isFirstSlide(3), isFalse);
      expect(OnboardingData.isFirstSlide(4), isFalse);

      expect(OnboardingData.isLastSlide(1), isFalse);
      expect(OnboardingData.isLastSlide(2), isFalse);
      expect(OnboardingData.isLastSlide(3), isFalse);
      expect(OnboardingData.isLastSlide(4), isTrue);
    });

    test('should use appropriate icons for each slide theme', () {
      // Arrange
      final slides = OnboardingData.slides;

      // Assert - Check that icons are appropriate for their themes
      expect(slides[0].icon, equals(Icons.account_balance_wallet)); // Income - wallet icon
      expect(slides[1].icon, equals(Icons.psychology)); // AI - brain/psychology icon
      expect(slides[2].icon, equals(Icons.savings)); // Savings - savings icon
      expect(slides[3].icon, equals(Icons.tune)); // Flexibility - tune/settings icon
    });

    test('should use gradient colors from AppColors constants', () {
      // Arrange
      final slides = OnboardingData.slides;

      // Assert - Check that gradients use predefined color constants
      expect(slides[0].gradientColors, equals(AppColors.gradientGreen));
      expect(slides[1].gradientColors, equals(AppColors.gradientBlue));
      expect(slides[2].gradientColors, equals(AppColors.gradientPurple));
      expect(slides[3].gradientColors, equals(AppColors.gradientGreen));
    });

    test('should have meaningful and descriptive content', () {
      // Assert
      for (final slide in OnboardingData.slides) {
        // Titles should be concise but descriptive
        expect(slide.title.length, greaterThan(5));
        expect(slide.title.length, lessThan(50));
        
        // Subtitles should be descriptive
        expect(slide.subtitle.length, greaterThan(20));
        expect(slide.subtitle.length, lessThan(150));
        
        // Should not contain placeholder text
        expect(slide.title.toLowerCase(), isNot(contains('lorem')));
        expect(slide.subtitle.toLowerCase(), isNot(contains('lorem')));
        expect(slide.title.toLowerCase(), isNot(contains('placeholder')));
        expect(slide.subtitle.toLowerCase(), isNot(contains('placeholder')));
      }
    });
  });
}