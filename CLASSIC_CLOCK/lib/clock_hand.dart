library;

import 'package:flutter/material.dart';
import 'package:my_classic_clock/clock_properties.dart';

class ClockHand extends StatelessWidget {
  final double angle;
  final double width;
  final double height;
  final Color color;
  final Alignment alignment;
  final double heightOffset;

  const ClockHand({
    required this.angle,
    required this.width,
    required this.height,
    required this.color,
    this.alignment = Alignment.topCenter,
    this.heightOffset = ClockProperties.clockHandHeightOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: heightOffset),
        Transform.rotate(
          angle: angle,
          alignment: alignment,
          child: Container(width: width, height: height, color: color),
        ),
      ],
    );
  }
}
