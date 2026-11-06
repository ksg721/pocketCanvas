import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_canvas/models/drawing_stroke.dart';

void main() {
  test('drawing strokes serialize and restore their data', () {
    final original = DrawingStroke(
      points: const [Offset(10, 20), Offset(30, 40)],
      color: const Color(0xff352f75),
      width: 12,
      isEraser: true,
    );

    final restored = DrawingStroke.fromJson(original.toJson());

    expect(restored.points, original.points);
    expect(restored.color, original.color);
    expect(restored.width, original.width);
    expect(restored.isEraser, original.isEraser);
  });
}
