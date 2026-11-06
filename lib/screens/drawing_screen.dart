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
  final List<DrawingStroke> _redoStrokes = [];
  Color _color = const Color(0xff352f75);
  double _width = 8;
  bool _isEraser = false;

  void _startStroke(Offset point) {
    _redoStrokes.clear();
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

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _redoStrokes.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStrokes.isEmpty) return;
    setState(() => _strokes.add(_redoStrokes.removeLast()));
  }

  Future<void> _confirmClear() async {
    if (_strokes.isEmpty) return;
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear drawing?'),
        content: const Text('This will remove all strokes from the canvas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (shouldClear == true && mounted) {
      setState(() {
        _strokes.clear();
        _redoStrokes.clear();
      });
    }
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
            onPressed: _strokes.isEmpty ? null : _undo,
            icon: const Icon(Icons.undo),
            tooltip: 'Undo'),
        IconButton(
            onPressed: _redoStrokes.isEmpty ? null : _redo,
            icon: const Icon(Icons.redo),
            tooltip: 'Redo'),
        IconButton(
            onPressed: _strokes.isEmpty ? null : _confirmClear,
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
