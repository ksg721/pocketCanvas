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

  Map<String, dynamic> toJson() => {
        'points': [
          for (final point in points) {'x': point.dx, 'y': point.dy},
        ],
        'color': color.value,
        'width': width,
        'isEraser': isEraser,
      };

  factory DrawingStroke.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? const [];
    return DrawingStroke(
      points: [
        for (final point in rawPoints)
          Offset(
            (point['x'] as num).toDouble(),
            (point['y'] as num).toDouble(),
          ),
      ],
      color: Color((json['color'] as num).toInt()),
      width: (json['width'] as num).toDouble(),
      isEraser: json['isEraser'] as bool? ?? false,
    );
  }
}
