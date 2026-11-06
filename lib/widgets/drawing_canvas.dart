import 'package:flutter/material.dart';

import '../models/drawing_stroke.dart';
import 'picture_background.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas(
      {super.key,
      required this.strokes,
      required this.onStart,
      required this.onUpdate,
      required this.onEnd});

  final List<DrawingStroke> strokes;
  final ValueChanged<Offset> onStart;
  final ValueChanged<Offset> onUpdate;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          const PictureBackground(),
          GestureDetector(
            onPanStart: (details) => onStart(details.localPosition),
            onPanUpdate: (details) => onUpdate(details.localPosition),
            onPanEnd: (_) => onEnd(),
            child: CustomPaint(
              painter: _StrokePainter(strokes),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  const _StrokePainter(this.strokes);
  final List<DrawingStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      if (stroke.isEraser) paint.blendMode = BlendMode.clear;
      if (stroke.points.length == 1) {
        canvas.drawCircle(stroke.points.first, stroke.width / 2,
            paint..style = PaintingStyle.fill);
        continue;
      }
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (final point in stroke.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  // The active stroke is mutated as the finger moves, so repaint every frame.
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}
