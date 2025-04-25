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

  // Dimensions
  static const double clockBorderWidth = 4.0;
  static const double hourHandLength = 60.0; // Shortest
  static const double minuteHandLength = 80.0;
  static const double secondHandLength = 100.0; // Longest
  static const double chrono1HandLength = hourHandLength * 0.8; // 80% of hour hand
  static const double chrono2HandLength = hourHandLength * 0.8; // 80% of hour hand
  
  static const double clock_left_margin = 30; 
  static const double clock_right_margin = 30; 
  static const double clock_top_margin = 30; 
  static const double clock_bottom_margin = 30; 
}