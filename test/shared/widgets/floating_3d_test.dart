import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/shared/widgets/floating_3d.dart';

void main() {
  testWidgets('Floating3D builds and animates child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Floating3D(
            intensity: 1.0,
            duration: Duration(milliseconds: 500),
            child: Icon(Icons.star),
          ),
        ),
      ),
    );

    // Initial build
    expect(find.byType(Floating3D), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Let animation tick
    await tester.pump(const Duration(milliseconds: 600));

    // Still present
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
