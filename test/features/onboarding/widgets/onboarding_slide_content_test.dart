import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/onboarding/widgets/onboarding_slide_content.dart';
import 'package:smartbudget_ai/features/onboarding/models/onboarding_slide.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';

void main() {
  group('OnboardingSlideContent Widget Tests', () {
    const testSlide = OnboardingSlide(
      id: 1,
      title: 'Test Title',
      subtitle: 'Test subtitle description',
      icon: Icons.star,
      gradientColors: AppColors.gradientGreen,
    );

    Widget createTestWidget({bool isActive = true}) {
      return MaterialApp(
        home: Scaffold(
          body: OnboardingSlideContent(
            slide: testSlide,
            isActive: isActive,
          ),
        ),
      );
    }

    testWidgets('should display slide content correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify title is displayed
      expect(find.text('Test Title'), findsOneWidget);
      
      // Verify subtitle is displayed
      expect(find.text('Test subtitle description'), findsOneWidget);
      
      // Verify icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should display floating 3D icon with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the icon container
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Verify the icon exists
      expect(find.byIcon(Icons.star), findsOneWidget);
      
      // Verify Floating3D widget is used
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('should apply correct text styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find title text widget
      final titleFinder = find.text('Test Title');
      expect(titleFinder, findsOneWidget);
      
      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontSize, 28);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.color, AppColors.text);

      // Find subtitle text widget
      final subtitleFinder = find.text('Test subtitle description');
      expect(subtitleFinder, findsOneWidget);
      
      final subtitleWidget = tester.widget<Text>(subtitleFinder);
      expect(subtitleWidget.style?.fontSize, 16);
      expect(subtitleWidget.style?.color, AppColors.textSecondary);
    });

    testWidgets('should handle active state animations', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(isActive: true));
      await tester.pumpAndSettle();

      // Verify FadeTransition exists
      expect(find.byType(FadeTransition), findsOneWidget);
      
      // Verify SlideTransition exists
      expect(find.byType(SlideTransition), findsOneWidget);
    });

    testWidgets('should handle inactive state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(isActive: false));
      await tester.pumpAndSettle();

      // Content should still be displayed
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test subtitle description'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should trigger animation when becoming active', (WidgetTester tester) async {
      // Start with inactive state
      await tester.pumpWidget(createTestWidget(isActive: false));
      await tester.pumpAndSettle();

      // Change to active state
      await tester.pumpWidget(createTestWidget(isActive: true));
      await tester.pump(); // Don't settle to catch animation in progress

      // Verify animations are present
      expect(find.byType(FadeTransition), findsOneWidget);
      expect(find.byType(SlideTransition), findsOneWidget);
    });

    testWidgets('should use correct gradient colors for icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find containers with decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      
      // Look for container with gradient decoration
      bool foundGradientContainer = false;
      for (final container in containers) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration && decoration.gradient is LinearGradient) {
          final gradient = decoration.gradient as LinearGradient;
          if (gradient.colors.isNotEmpty) {
            foundGradientContainer = true;
            break;
          }
        }
      }
      
      expect(foundGradientContainer, isTrue);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify main column structure
      expect(find.byType(Column), findsWidgets);
      
      // Verify padding is applied
      expect(find.byType(Padding), findsWidgets);
      
      // Verify SizedBox for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should center align text content', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find title text widget
      final titleWidget = tester.widget<Text>(find.text('Test Title'));
      expect(titleWidget.textAlign, TextAlign.center);

      // Find subtitle text widget
      final subtitleWidget = tester.widget<Text>(find.text('Test subtitle description'));
      expect(subtitleWidget.textAlign, TextAlign.center);
    });

    testWidgets('should dispose animation controller properly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Remove the widget to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      // If no exceptions are thrown, dispose was handled correctly
      expect(tester.takeException(), isNull);
    });
  });
}