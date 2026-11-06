import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/saved_drawing.dart';
import '../widgets/drawing_canvas.dart';
import 'drawing_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const _galleryKey = 'pocket_canvas.saved_drawings';
  late Future<List<SavedDrawing>> _drawings;

  @override
  void initState() {
    super.initState();
    _drawings = _readDrawings();
  }

  Future<List<SavedDrawing>> _readDrawings() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_galleryKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return [
        for (final drawing in decoded)
          SavedDrawing.fromJson(drawing as Map<String, dynamic>),
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeDrawings(List<SavedDrawing> drawings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _galleryKey,
      jsonEncode(drawings.map((drawing) => drawing.toJson()).toList()),
    );
  }

  Future<void> _rename(SavedDrawing drawing) async {
    final controller = TextEditingController(text: drawing.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename drawing'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(labelText: 'Drawing name'),
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    final drawings = await _drawings;
    final updated = [
      for (final item in drawings)
        item.id == drawing.id ? drawing.copyWith(name: name) : item,
    ];
    await _writeDrawings(updated);
    if (mounted) setState(() => _drawings = Future.value(updated));
  }

  Future<void> _delete(SavedDrawing drawing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete drawing?'),
        content: Text('Remove “${drawing.name}” from your gallery?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final drawings = await _drawings;
    final updated = drawings.where((item) => item.id != drawing.id).toList();
    await _writeDrawings(updated);
    if (mounted) setState(() => _drawings = Future.value(updated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: FutureBuilder<List<SavedDrawing>>(
        future: _drawings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final drawings = snapshot.data!;
          if (drawings.isEmpty) {
            return _EmptyGallery(onCreate: () => Navigator.pop(context));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: .82,
            ),
            itemCount: drawings.length,
            itemBuilder: (context, index) {
              final drawing = drawings[index];
              return _DrawingCard(
                drawing: drawing,
                onOpen: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DrawingScreen(initialDrawing: drawing),
                  ),
                ),
                onRename: () => _rename(drawing),
                onDelete: () => _delete(drawing),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DrawingScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New drawing'),
      ),
    );
  }
}

class _DrawingCard extends StatelessWidget {
  const _DrawingCard({
    required this.drawing,
    required this.onOpen,
    required this.onRename,
    required this.onDelete,
  });

  final SavedDrawing drawing;
  final VoidCallback onOpen;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DrawingCanvas(
                  strokes: drawing.strokes,
                  onStart: (_) {},
                  onUpdate: (_) {},
                  onEnd: () {},
                ),
              ),
            ),
            ListTile(
              dense: true,
              title: Text(drawing.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${drawing.strokes.length} strokes'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') onRename();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined,
                size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('Your gallery is empty',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Save a drawing to see it here.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.brush_outlined),
              label: const Text('Create a drawing'),
            ),
          ],
        ),
      ),
    );
  }
}
