import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'widgets/calculator_layout.dart';

void main() {
  runApp(const SumTwoNumbers());
}

class SumTwoNumbers extends StatelessWidget {
  const SumTwoNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            textTheme: const TextTheme(
                titleLarge: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
            )
        ),
        title: 'Sum Two Numbers', 
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: prefer_final_fields
  final int _currentColorIndex = 0;
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _result = '';

  void _calculate() {
    setState(() {
      final input1 = double.tryParse(_input1Controller.text);
      final input2 = double.tryParse(_input2Controller.text);
      if (input1 != null && input2 != null) {
        _result = (input1 + input2).toString();
      } else {
        _result = 'Invalid input';
      }
    });
  }

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPairs[_currentColorIndex]['title'],
        title: Text('Calculator App', style: TextStyle(color: AppColors.myColorPairs['normtext'])),
      ),
      body: CalculatorLayout(
        input1Controller: _input1Controller,
        input2Controller: _input2Controller,
        outputController: _outputController,
        onCalculate: _calculate,
        result: _result,
      ),
    );
  }
}