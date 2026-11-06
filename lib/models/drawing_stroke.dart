import 'package:flutter/material.dart';

class DrawingStroke {
  DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isEraser = false,
  });

  final List<Offset> points;
  final Color color;
  final double width;
  final bool isEraser;
}
