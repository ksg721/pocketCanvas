import 'dart:convert';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import '../models/drawing_stroke.dart';
import '../models/saved_drawing.dart';
import '../widgets/drawing_canvas.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key, this.initialDrawing});

  final SavedDrawing? initialDrawing;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  static const _savedDrawingKey = 'pocket_canvas.saved_drawing';
  final _canvasKey = GlobalKey();
  final List<DrawingStroke> _strokes = [];
  final List<DrawingStroke> _redoStrokes = [];
  static const _palette = [
    Color(0xff352f75),
    Color(0xff1f3a5f),
    Color(0xff147d92),
    Color(0xff25855a),
    Color(0xff8da31f),
    Color(0xffffb300),
    Color(0xfff27c38),
    Color(0xffd94f70),
    Color(0xff9c4dcc),
    Color(0xff5f6caf),
    Color(0xff222222),
    Color(0xfff7f4ef),
  ];
  Color _color = const Color(0xff352f75);
  double _width = 8;
  bool _isEraser = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDrawing != null) {
      _strokes.addAll(widget.initialDrawing!.strokes);
    } else {
      _loadDrawing(showMessage: false);
    }
  }

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

  Future<void> _saveDrawing() async {
    final preferences = await SharedPreferences.getInstance();
    final savedDrawing = SavedDrawing(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: 'Drawing ${DateTime.now().month}/${DateTime.now().day}',
      createdAt: DateTime.now(),
      strokes: List.of(_strokes),
    );
    final existing = preferences.getString('pocket_canvas.saved_drawings');
    final drawings = existing == null || existing.isEmpty
        ? <SavedDrawing>[]
        : [
            for (final drawing in jsonDecode(existing) as List<dynamic>)
              SavedDrawing.fromJson(drawing as Map<String, dynamic>),
          ];
    drawings.insert(0, savedDrawing);
    await preferences.setString(
      'pocket_canvas.saved_drawings',
      jsonEncode(drawings.map((drawing) => drawing.toJson()).toList()),
    );
    await preferences.setString(
      _savedDrawingKey,
      jsonEncode(_strokes.map((stroke) => stroke.toJson()).toList()),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drawing saved to your gallery.')),
    );
  }

  Future<void> _loadDrawing({bool showMessage = true}) async {
    final preferences = await SharedPreferences.getInstance();
    final savedDrawing = preferences.getString(_savedDrawingKey);
    if (savedDrawing == null || savedDrawing.isEmpty || !mounted) return;
    try {
      final decoded = jsonDecode(savedDrawing) as List<dynamic>;
      final restoredStrokes = [
        for (final stroke in decoded)
          DrawingStroke.fromJson(stroke as Map<String, dynamic>),
      ];
      setState(() {
        _strokes
          ..clear()
          ..addAll(restoredStrokes);
        _redoStrokes.clear();
      });
      if (showMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved drawing loaded.')),
        );
      }
    } on FormatException {
      if (showMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The saved drawing could not be read.')),
        );
      }
    }
  }

  Future<void> _exportDrawing() async {
    final renderObject = _canvasKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return;
    final image = await renderObject.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null || !mounted) return;
    final pngBytes = byteData.buffer.asUint8List();
    final result = await SharePlus.instance.share(
      ShareParams(
        title: 'Pocket Canvas drawing',
        text: 'My Pocket Canvas drawing',
        files: [XFile.fromData(pngBytes, mimeType: 'image/png')],
        fileNameOverrides: ['pocket_canvas.png'],
      ),
    );
    if (!mounted || result.status == ShareResultStatus.dismissed) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drawing exported as a PNG.')),
    );
  }

  Future<void> _pickColor() async {
    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose a color'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final color in _palette)
              Semantics(
                button: true,
                label: 'Color swatch',
                child: InkWell(
                  onTap: () => Navigator.pop(context, color),
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 22,
                    child: _color == color
                        ? Icon(Icons.check,
                            color: color.computeLuminance() > .5
                                ? Colors.black
                                : Colors.white)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (selectedColor != null && mounted) {
      setState(() => _color = selectedColor);
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
            onPressed: _saveDrawing,
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save drawing'),
        IconButton(
            onPressed: _loadDrawing,
            icon: const Icon(Icons.folder_open_outlined),
            tooltip: 'Load drawing'),
        IconButton(
            onPressed: _exportDrawing,
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: 'Export drawing'),
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
                child: RepaintBoundary(
              key: _canvasKey,
              child: DrawingCanvas(
                  strokes: _strokes,
                  onStart: _startStroke,
                  onUpdate: _updateStroke,
                  onEnd: () {}),
            )),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final color in colors.take(4))
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
                  onPressed: _pickColor,
                  icon: const Icon(Icons.palette_outlined),
                  tooltip: 'Choose a color',
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () => setState(() => _isEraser = !_isEraser),
                  icon: Icon(_isEraser ? Icons.brush : Icons.auto_fix_high),
                  tooltip: _isEraser ? 'Use brush' : 'Use eraser',
                ),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.brush_outlined, size: 20),
                Expanded(
                  child: Slider(
                    value: _width,
                    min: 2,
                    max: 32,
                    divisions: 15,
                    label: '${_width.round()} px',
                    onChanged: (value) => setState(() => _width = value),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: Text('${_width.round()} px', textAlign: TextAlign.end),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
