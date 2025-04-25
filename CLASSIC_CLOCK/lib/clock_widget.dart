library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'clock_properties.dart';
import 'clock_hands.dart';
import 'clock_number.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ClockHandsState> clockHandsKey =
        GlobalKey<ClockHandsState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(
          constraints.maxWidth*ClockProperties.clockWidthRatio,
          constraints.maxHeight*ClockProperties.clockHeightRatio,
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: ClockProperties.heightOffset),

              /// ---------------------------------------------- ///
              Container(
                margin: const EdgeInsets.all(20),
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    /// Tạo vòng tròn
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ClockProperties.clockFaceColor,
                        border: Border.all(
                          color: ClockProperties.clockBorderColor,
                          width: ClockProperties.clockBorderWidth,
                        ),
                      ),
                    ),

                    /// tạo các vạch ---------------------------- ///
                    ...List.generate(60, (index) {
                      return Transform.rotate(
                        angle: index * (2 * pi / 60),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 2,
                            height: index % 50 == 0 ? 12 : 8,
                            margin: const EdgeInsets.only(top: 8),
                            color: const Color.fromARGB(255, 131, 131, 131),
                          ),
                        ),
                      );
                    }),

                    /// tạo các số ------------------------------ ///
                    ClockNumber(
                      number: '12',
                      angle: 0,
                      alignment: Alignment.topCenter,
                    ),
                    ClockNumber(
                      number: '3',
                      angle: pi / 2,
                      alignment: Alignment.topCenter,
                    ),
                    ClockNumber(
                      number: '9',
                      angle: pi,
                      alignment: Alignment.topCenter,
                    ),
                    ClockNumber(
                      number: '6',
                      angle: 3 * pi / 2,
                      alignment: Alignment.topCenter,
                    ),
                    /// tạo các kim ---------------------------- ///
                    ClockHands(key: clockHandsKey),
                  ],
                ),
              ),

              /// tạo nút nhấn --------------------------------- ///
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      clockHandsKey.currentState?.updateChrono1();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClockProperties.buttonColor,
                    ),
                    child: const Text(
                      'Bấm giờ 1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      clockHandsKey.currentState?.updateChrono2();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ClockProperties.buttonColor,
                    ),
                    child: const Text(
                      'Bấm giờ 2',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
