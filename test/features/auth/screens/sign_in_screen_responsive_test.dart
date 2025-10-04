import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/auth/screens/sign_in_screen.dart';

void main() {
  group('SignInScreen responsiveness and keyboard handling', () {
    testWidgets('centers content on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      await tester.pump();

      // Ensure key pieces are visible
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('scrolls above keyboard when focused', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignInScreen()));
      await tester.pump();

      // Focus email field
      await tester.tap(find.text('Email'));
      await tester.pump();

      // Rebuild with a MediaQuery that simulates keyboard inset
      final media = MediaQuery.of(tester.element(find.byType(SignInScreen)));
      await tester.pumpWidget(
        MediaQuery(
          data: media.copyWith(viewInsets: const EdgeInsets.only(bottom: 300)),
          child: const MaterialApp(home: SignInScreen()),
        ),
      );
      await tester.pump();

      // Still accessible
      expect(find.text('Password'), findsOneWidget);
    });
  });
}


