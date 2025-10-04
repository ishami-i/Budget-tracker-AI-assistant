import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/widgets/glass_background.dart';
import 'package:smartbudget_ai/core/constants/colors.dart';

void main() {
  group('GlassBackground Widget Tests', () {
    testWidgets('should render child widget correctly', (WidgetTester tester) async {
      const testChild = Text('Test Child');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              child: testChild,
            ),
          ),
        ),
      );
      
      expect(find.text('Test Child'), findsOneWidget);
    });
    
    testWidgets('should display glass overlay by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      // Find BackdropFilter which indicates glass overlay is present
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
    
    testWidgets('should hide glass overlay when showOverlay is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              showOverlay: false,
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      // BackdropFilter should not be present when overlay is disabled
      expect(find.byType(BackdropFilter), findsNothing);
    });
    
    testWidgets('should use custom orbs when provided', (WidgetTester tester) async {
      final customOrbs = [
        GlassOrb(
          size: 100,
          position: const Offset(50, 50),
          colors: AppColors.orbGreen,
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              customOrbs: customOrbs,
              child: const Text('Test'),
            ),
          ),
        ),
      );
      
      // Should find CustomPaint widget for orb rendering (at least one)
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });
    
    testWidgets('should create animation controllers for orbs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      // Pump frames to allow animations to initialize
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      
      // Should find CustomPaint widget for orb rendering (at least one)
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });
    
    testWidgets('should apply custom blur intensity', (WidgetTester tester) async {
      const customBlur = 25.0;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              blurIntensity: customBlur,
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      // Should find BackdropFilter with custom blur
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
    
    testWidgets('should dispose animation controllers properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassBackground(
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      // Pump to initialize
      await tester.pump();
      
      // Remove the widget to trigger dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Different Widget'),
          ),
        ),
      );
      
      // Pump and settle to complete all animations and timers
      await tester.pumpAndSettle();
      
      // Should not throw any errors during disposal
      expect(tester.takeException(), isNull);
    });
  });
  
  group('GlassOrb Model Tests', () {
    test('should create GlassOrb with required parameters', () {
      const orb = GlassOrb(
        size: 200.0,
        position: Offset(100, 100),
        colors: AppColors.orbGreen,
      );
      
      expect(orb.size, equals(200.0));
      expect(orb.position, equals(const Offset(100, 100)));
      expect(orb.colors, equals(AppColors.orbGreen));
      expect(orb.animationDuration, equals(const Duration(seconds: 4)));
    });
    
    test('should create GlassOrb with custom animation duration', () {
      const customDuration = Duration(seconds: 2);
      const orb = GlassOrb(
        size: 150.0,
        position: Offset(50, 50),
        colors: AppColors.orbBlue,
        animationDuration: customDuration,
      );
      
      expect(orb.animationDuration, equals(customDuration));
    });
  });
  
  group('GlassOrbPainter Tests', () {
    test('should create painter with required parameters', () {
      final orbs = [
        const GlassOrb(
          size: 100,
          position: Offset(0, 0),
          colors: AppColors.orbGreen,
        ),
      ];
      
      // Create a mock animation controller for testing
      final mockAnimation = AlwaysStoppedAnimation<double>(0.5);
      final animations = [mockAnimation];
      
      final painter = GlassOrbPainter(
        orbs: orbs,
        animations: animations,
      );
      
      expect(painter.orbs, equals(orbs));
      expect(painter.animations, equals(animations));
    });
    
    test('should indicate repaint when orbs change', () {
      final orbs1 = [
        const GlassOrb(
          size: 100,
          position: Offset(0, 0),
          colors: AppColors.orbGreen,
        ),
      ];
      
      final orbs2 = [
        const GlassOrb(
          size: 200,
          position: Offset(50, 50),
          colors: AppColors.orbBlue,
        ),
      ];
      
      final mockAnimation = AlwaysStoppedAnimation<double>(0.5);
      final animations = [mockAnimation];
      
      final painter1 = GlassOrbPainter(orbs: orbs1, animations: animations);
      final painter2 = GlassOrbPainter(orbs: orbs2, animations: animations);
      
      expect(painter1.shouldRepaint(painter2), isTrue);
    });
  });
}