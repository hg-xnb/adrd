import 'package:flutter/material.dart';

class ClockProperties {
  // Colors
  static const Color clockFaceColor = Colors.white;
  static const Color clockBorderColor = Colors.black;
  static const Color tickColor = Colors.black;
  static const Color hourHandColor = Colors.black;
  static const Color minuteHandColor = Colors.black;
  static const Color secondHandColor = Colors.red;
  static const Color chrono1HandColor = Colors.yellow;
  static const Color chrono2HandColor = Colors.green;
  static const Color buttonColor = Colors.blue;
  static const Color deltaColor = Colors.black87;

  // Dimensions
  static const double clockBorderWidth = 4.0;
  static const double hourHandLength = 60.0; // Shortest
  static const double minuteHandLength = 80.0;
  static const double secondHandLength = 100.0; // Longest
  static const double chrono1HandLength = secondHandLength * 1.05;
  static const double chrono2HandLength = secondHandLength * 1.1;

  static const double clockWidthRatio = 0.8;
  static const double clockHeightRatio = 0.8;

  static const double clockHandHeightOffset = 100;

  static const double heightOffset = 230;
}