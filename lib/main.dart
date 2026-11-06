import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const PocketCanvasApp());
}

class PocketCanvasApp extends StatelessWidget {
  const PocketCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Canvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6c63ff)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
