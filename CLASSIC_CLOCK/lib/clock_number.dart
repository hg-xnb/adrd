library;
import 'package:flutter/material.dart';

class ClockNumber extends StatelessWidget {
  final String number;
  final double angle;
  final Alignment alignment;
  const ClockNumber({
    required this.number,
    required this.angle,
    required this.alignment,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: alignment,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text(
            number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
