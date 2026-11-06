import 'package:flutter/material.dart';

import 'drawing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.palette_rounded,
                      size: 64, color: colors.primary),
                ),
                const SizedBox(height: 24),
                Text('Pocket Canvas',
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 10),
                Text(
                  'A tiny canvas for big ideas.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 34),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DrawingScreen()),
                  ),
                  icon: const Icon(Icons.brush_rounded),
                  label: const Text('Start drawing'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
