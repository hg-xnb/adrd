import 'package:flutter/material.dart';
import 'clock_widget.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Center(
          child: ClockWidget(),
        ),
      ),
    );
  }
}