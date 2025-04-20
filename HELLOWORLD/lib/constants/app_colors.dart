// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const List<Map<String, Color>> colorPairs = [
    {'title': Color(0xFF077A7D), 'background': Color(0xFFF5EEDD), 
    'outline':Color(0xFF06202B), 'focusoutline':Color(0xFF077A7D)},

    {'title': Color(0xFF3B6062), 'background': Color(0xFFF6B8A0), 
    'outline':Color(0xFF06202B), 'focusoutline':Color(0xFF077A7D)},

    {'title': Color(0xFF704647), 'background': Color(0xFFF66577),
    'outline':Color(0xFF06202B), 'focusoutline':Color(0xFF077A7D)},

    {'title': Color(0xFFA62C2C), 'background': Color(0xFFF7374F), 
    'outline':Color(0xFF06202B), 'focusoutline':Color(0xFF077A7D)},
  ];

  static const Map<String, Color> myColorPairs = {
    'normtext' : Color(0xFFFFFFFF),
    'title': Color(0xFF077A7D), 
    'background': Color(0xFFF5EEDD), 
    'disableoutline':Color.fromARGB(255, 167, 211, 212),
    'outline':Color(0xFF3B6062), 
    'focusoutline':Color(0xFF06202B),
    'button': Color(0xFF3B6062),
    'clear-button' : Color.fromARGB(255, 98, 59, 80),
    'calc-button': Color(0xFF3B6062),
  };
}