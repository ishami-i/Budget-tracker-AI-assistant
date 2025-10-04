import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/widgets/glass_button.dart';

void main() {
  testWidgets('GlassButton shows loading indicator when isLoading is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PrimaryGlassButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('GlassButton onPressed is called when tapped and not loading', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PrimaryGlassButton(
              text: 'Tap',
              isLoading: false,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
