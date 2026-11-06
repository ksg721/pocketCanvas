import 'drawing_stroke.dart';

class SavedDrawing {
  const SavedDrawing({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.strokes,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final List<DrawingStroke> strokes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'strokes': [for (final stroke in strokes) stroke.toJson()],
      };

  factory SavedDrawing.fromJson(Map<String, dynamic> json) => SavedDrawing(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        strokes: [
          for (final stroke in json['strokes'] as List<dynamic>)
            DrawingStroke.fromJson(stroke as Map<String, dynamic>),
        ],
      );

  SavedDrawing copyWith({String? name}) => SavedDrawing(
        id: id,
        name: name ?? this.name,
        createdAt: createdAt,
        strokes: strokes,
      );
}
