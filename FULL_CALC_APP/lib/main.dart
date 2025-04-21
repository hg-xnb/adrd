import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'widgets/calculator_core.dart';
import 'widgets/calculator_layout.dart';

void main() {
  runApp(const FullCalculator());
}

class FullCalculator extends StatelessWidget {
  const FullCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      title: 'Full Calculator',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Calculator calculator = Calculator();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorPairs['title'],
        title: Text(
          'Calculator App',
          style: TextStyle(color: AppColors.myColorPairs['homebar-text']),
        ),
      ),
      body: CalculatorLayout(
        calculator: calculator,
        onStateChanged: () {
          setState(() {});
        },
      ),
    );
  }
}
