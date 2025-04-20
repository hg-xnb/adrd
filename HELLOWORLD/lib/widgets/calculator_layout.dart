// lib/widgets/calculator_layout.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CalculatorLayout extends StatelessWidget {
  final TextEditingController input1Controller;
  final TextEditingController input2Controller;
  final TextEditingController outputController;
  final VoidCallback onCalculate;
  final VoidCallback onClear;
  final String result;

  const CalculatorLayout({
    super.key,
    required this.input1Controller,
    required this.input2Controller,
    required this.outputController,
    required this.onCalculate,
    required this.onClear,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Update outputController with result
    outputController.text = result;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 100),

          /// A ROW WITH INPUT 1 AND INPUT 2 ///////////////////////////////////////////
          Row(
            children: [
              /// INPUT 1 //////////////////////////////////////////////////////////////
              Expanded(
                child: TextField(
                  controller: input1Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['disableoutline']!,
                      ),
                    ),
                    labelText: 'Input 1',
                    labelStyle: TextStyle(
                      color: AppColors.myColorPairs['title']!,
                    ),
                    floatingLabelAlignment:
                        FloatingLabelAlignment.start, // Match output
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['focusoutline']!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['outline']!,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100, // Match output
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.myColorPairs['title']!,
                    fontSize: 18, // Match output
                  ),
                ),
              ),

              const SizedBox(width: 16.0),

              /// INPUT 2 //////////////////////////////////////////////////////////////
              Expanded(
                child: TextField(
                  controller: input2Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['disableoutline']!,
                      ),
                    ),
                    labelText: 'Input 2',
                    labelStyle: TextStyle(
                      color: AppColors.myColorPairs['title']!,
                    ),
                    floatingLabelAlignment:
                        FloatingLabelAlignment.start, // Match output
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['focusoutline']!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.myColorPairs['outline']!,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100, // Match output
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.myColorPairs['title']!,
                    fontSize: 18, // Match output
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30.0),

          /// CALC BUTTON //////////////////////////////////////////////////////////////
          Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                  child: ElevatedButton(
                    onPressed: onCalculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myColorPairs['calc-button']!,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                    ),
                    child: const Text(
                      'Calc',
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            Colors
                                .white, // Explicitly set to match foregroundColor
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16,)
              ,
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                  child: ElevatedButton(
                    onPressed: onClear,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myColorPairs['clear-button']!,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 16.0,
                      ),
                    ),
                    child: const Text(
                      'Clr',
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            Colors
                                .white, // Explicitly set to match foregroundColor
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Center(
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
          //     child: ElevatedButton(
          //       onPressed: onCalculate,
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.myColorPairs['title']!,
          //         foregroundColor: Colors.white,
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 32.0,
          //           vertical: 16.0,
          //         ),
          //       ),
          //       child: const Text(
          //         'Calc',
          //         style: TextStyle(
          //           fontSize: 18,
          //           color:
          //               Colors.white, // Explicitly set to match foregroundColor
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30.0),

          /// OUTPUT TEXTFIELD /////////////////////////////////////////////////////////
          SizedBox(
            width: screenWidth * 0.9,
            child: TextField(
              controller: outputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.myColorPairs['disableoutline']!,
                  ),
                ),
                labelText: 'Result',
                labelStyle: TextStyle(color: AppColors.myColorPairs['title']),
                floatingLabelAlignment: FloatingLabelAlignment.start,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.myColorPairs['focusoutline']!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.myColorPairs['outline']!,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.myColorPairs['title'],
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
