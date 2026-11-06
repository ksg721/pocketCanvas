import 'package:flutter/material.dart';

import '../models/drawing_stroke.dart';
import '../widgets/drawing_canvas.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<DrawingStroke> _strokes = [];
  Color _color = const Color(0xff352f75);
  double _width = 8;
  bool _isEraser = false;

  void _startStroke(Offset point) {
    setState(() => _strokes.add(DrawingStroke(
          points: [point],
          color: _color,
          width: _width,
          isEraser: _isEraser,
        )));
  }

  void _updateStroke(Offset point) {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(point));
  }

  void _clear() => setState(_strokes.clear);

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.indigo.shade900,
      Colors.pink.shade400,
      Colors.teal.shade700,
      Colors.amber.shade800
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('New drawing'), actions: [
        IconButton(
            onPressed: _undo, icon: const Icon(Icons.undo), tooltip: 'Undo'),
        IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear')
      ]),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Expanded(
                child: DrawingCanvas(
                    strokes: _strokes,
                    onStart: _startStroke,
                    onUpdate: _updateStroke,
                    onEnd: () {})),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final color in colors)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => setState(() => _color = color),
                      borderRadius: BorderRadius.circular(30),
                      child: CircleAvatar(
                          backgroundColor: color,
                          child: _color == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null),
                    ),
                  ),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () => setState(() => _isEraser = !_isEraser),
                  icon: Icon(_isEraser ? Icons.brush : Icons.auto_fix_high),
                  tooltip: _isEraser ? 'Use brush' : 'Use eraser',
                ),
                const SizedBox(width: 8),
                SegmentedButton<double>(
                  segments: const [
                    ButtonSegment(value: 4, label: Text('S')),
                    ButtonSegment(value: 8, label: Text('M')),
                    ButtonSegment(value: 16, label: Text('L'))
                  ],
                  selected: {_width},
                  onSelectionChanged: (value) =>
                      setState(() => _width = value.first),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
