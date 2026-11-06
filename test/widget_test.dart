import 'package:flutter_test/flutter_test.dart';

import 'package:pocket_canvas/main.dart';

void main() {
  testWidgets('home screen opens the drawing screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PocketCanvasApp());

    expect(find.text('Pocket Canvas'), findsOneWidget);
    expect(find.text('Start drawing'), findsOneWidget);

    await tester.tap(find.text('Start drawing'));
    await tester.pumpAndSettle();

    expect(find.text('New drawing'), findsOneWidget);
  });
}
