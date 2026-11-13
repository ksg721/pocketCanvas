import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_wheel_picker/flutter_color_wheel_picker.dart';

import 'package:pocket_canvas/main.dart';
import 'package:pocket_canvas/widgets/drawing_canvas.dart';

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

  testWidgets('clear asks for confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(const PocketCanvasApp());
    await tester.tap(find.text('Start drawing'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(DrawingCanvas), const Offset(40, 20));
    await tester.pump();

    await tester.tap(find.byTooltip('Clear'));
    await tester.pumpAndSettle();

    expect(find.text('Clear drawing?'), findsOneWidget);
    expect(find.text('This will remove all strokes from the canvas.'),
        findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Clear drawing?'), findsNothing);
  });

  testWidgets(
      'preset colors, color wheel, and brush size controls are available',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PocketCanvasApp());
    await tester.tap(find.text('Start drawing'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Choose a color'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a custom color'), findsOneWidget);
    expect(find.byType(ColorWheelPicker), findsOneWidget);

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a custom color'), findsNothing);
    expect(find.bySemanticsLabel('Preset color 1'), findsOneWidget);
    expect(find.bySemanticsLabel('Preset color 10'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('blank is the default and image chooser is available',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PocketCanvasApp());
    await tester.tap(find.text('Start drawing'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Choose an image'));
    await tester.pumpAndSettle();

    expect(find.text('Choose an image'), findsOneWidget);
    expect(find.text('Blank'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('Mountains'), findsOneWidget);
    expect(find.text('Garden'), findsOneWidget);
  });
}
