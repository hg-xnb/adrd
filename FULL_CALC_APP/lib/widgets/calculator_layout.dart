// lib/widgets/calculator_layout.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/calculator_core.dart';
import '../constants/app_size.dart';

class DisplayBox extends StatelessWidget {
  final double height;
  final double width;
  final double padding;
  final double radius;
  final double fontsize;
  final Alignment textAlignment;
  final String text;
  final Color border;
  final bool softWrap = true;

  const DisplayBox({
    super.key,
    required this.height,
    required this.width,
    required this.padding,
    required this.radius,
    required this.border,
    required this.fontsize,
    required this.text,
    required this.textAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // 30.0
      width: width, // 120.0
      alignment: textAlignment,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 1.0),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontsize),
        softWrap: softWrap,
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onLongPressed; // Optional long press callback

  const BuildButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.onLongPressed, // Optional parameter for long press
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed, // Detect long press if onLongPressed is provided
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(80, 80),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}


class CalculatorLayout extends StatelessWidget {
  final Calculator calculator;
  final VoidCallback onStateChanged;
  const CalculatorLayout({
    super.key,
    required this.calculator,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          DisplayBox(
            height: AppProperties.size['box-expr-high']!,
            width: AppProperties.size['box-expr-width']!,
            padding: AppProperties.size['expr-box-padding']!,
            border: AppColors.myColorPairs['expr-box-border']!,
            radius: 8,
            fontsize: AppProperties.size['expr-font-size']!,
            text: calculator.expression,
            textAlignment: Alignment.topLeft,
          ),

          const SizedBox(height: 5),

          DisplayBox(
            height: AppProperties.size['box-res-high']!,
            width: AppProperties.size['box-res-width']!,
            padding: AppProperties.size['res-box-padding']!,
            border: AppColors.myColorPairs['res-box-border']!,
            radius: 8,
            fontsize: AppProperties.size['res-font-size']!,
            text: calculator.result,
            textAlignment: Alignment.centerRight,
          ),

          const SizedBox(height: 30),

          /// ---------------------------------------------------------
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                // BuildButton(
                //   label: 'C',
                //   onPressed: () {
                //     calculator.clearAll();
                //     onStateChanged();
                //   },
                //   backgroundColor: AppColors.myColorPairs['button-light']!,
                //   textColor: Colors.black,
                // ),
                /// ROW 1 ----------------------------------------------------------
                BuildButton(
                  label: '⌫',
                  onPressed: () {
                    calculator.removeDigit();
                    onStateChanged();
                  },
                  onLongPressed: (){
                    calculator.clearAll();
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-light']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '(',
                  onPressed: () {
                    calculator.addBracket();
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-light']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: ')',
                  onPressed: () {
                    calculator.addBracket();
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-light']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '÷',
                  onPressed: () {
                    calculator.addOperator('÷', '÷');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-orange']!,
                  textColor: Colors.black,
                ),
                /// ROW 2 ----------------------------------------------------------
                BuildButton(
                  label: '7',
                  onPressed: () {
                    calculator.addDigit('7');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),

                BuildButton(
                  label: '8',
                  onPressed: () {
                    calculator.addDigit('8');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '9',
                  onPressed: () {
                    calculator.addDigit('9');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '×',
                  onPressed: () {
                    calculator.addOperator('x', 'x');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-orange']!,
                  textColor: Colors.black,
                ),
                /// ROW 3 ----------------------------------------------------------
                BuildButton(
                  label: '4',
                  onPressed: () {
                    calculator.addDigit('4');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '5',
                  onPressed: () {
                    calculator.addDigit('5');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '6',
                  onPressed: () {
                    calculator.addDigit('6');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '+',
                  onPressed: () {
                    calculator.addOperator('+', '+');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-orange']!,
                  textColor: Colors.black,
                ),
                /// ROW 4 ----------------------------------------------------------
                BuildButton(
                  label: '1',
                  onPressed: () {
                    calculator.addDigit('1');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '2',
                  onPressed: () {
                    calculator.addDigit('2');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '3',
                  onPressed: () {
                    calculator.addDigit('3');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '-',
                  onPressed: () {
                    calculator.addOperator('-', '-');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-orange']!,
                  textColor: Colors.black,
                ),
                /// ROW 5 ----------------------------------------------------------
                BuildButton(
                  label: 'ANS',
                  onPressed: () {
                    calculator.addANS();
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-light']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '0',
                  onPressed: () {
                    calculator.addDigit('0');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '.',
                  onPressed: () {
                    calculator.addDigit('.');
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['normtext']!,
                  textColor: Colors.black,
                ),
                BuildButton(
                  label: '=',
                  onPressed: () {
                    calculator.calc();
                    onStateChanged();
                  },
                  backgroundColor: AppColors.myColorPairs['button-blue']!,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),

          /// ---------------------------------------------------------
        ],
      ),
    );
  }
}
