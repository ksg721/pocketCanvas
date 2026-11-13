import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_canvas/models/drawing_stroke.dart';
import 'package:pocket_canvas/models/saved_drawing.dart';
import 'package:pocket_canvas/models/canvas_background.dart';

void main() {
  test('saved drawings serialize their metadata and strokes', () {
    final original = SavedDrawing(
      id: 'drawing-1',
      name: 'Sunset',
      createdAt: DateTime(2026, 11, 6),
      strokes: [
        DrawingStroke(
          points: const [Offset(4, 8)],
          color: Colors.deepPurple,
          width: 6,
        ),
      ],
      background: CanvasBackground.mountains,
    );

    final restored = SavedDrawing.fromJson(original.toJson());

    expect(restored.id, original.id);
    expect(restored.name, original.name);
    expect(restored.createdAt, original.createdAt);
    expect(restored.strokes.single.points, original.strokes.single.points);
    expect(restored.background, CanvasBackground.mountains);
  });
}
