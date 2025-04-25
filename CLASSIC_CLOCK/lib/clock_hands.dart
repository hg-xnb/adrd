library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'clock_properties.dart';
import 'clock_hand.dart';

class ClockHands extends StatefulWidget {
  const ClockHands({super.key});

  @override
  ClockHandsState createState() => ClockHandsState();
}

class ClockHandsState extends State<ClockHands> {
  static const _anglePerHour = 2 * pi / 12;
  static const _anglePerMinute = 2 * pi / 60;
  static const _anglePerSecond = 2 * pi / 60;

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  double _chrono1MiliSecond = 0;
  double _chrono1Angle = 0;
  double _chrono2MiliSecond = 0;
  double _chrono2Angle = 0;
  double _hourAngle = 0;
  double _minuteAngle = 0;
  double _secondAngle = 0;
  double _delta = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() => _currentTime = DateTime.now());
    });
  }

  void updateAngles() {
    final hour = _currentTime.hour % 12 + _currentTime.minute / 60;
    final minute = _currentTime.minute + _currentTime.second / 60;
    final second = _currentTime.second + _currentTime.millisecond / 1000;

    _hourAngle = hour * _anglePerHour;
    _minuteAngle = minute * _anglePerMinute;
    _secondAngle = second * _anglePerSecond;
  }

  void updateDelta() {
    _delta = (_chrono2MiliSecond - _chrono1MiliSecond) / 1000;
  }

  void updateChrono1() {
    setState(() {
      _chrono1Angle = _secondAngle;
      _chrono1MiliSecond =
          _currentTime.second.toDouble() * 1000 + _currentTime.microsecond;
    });
  }

  void updateChrono2() {
    setState(() {
      _chrono2Angle = _secondAngle;
      _chrono2MiliSecond =
          _currentTime.second.toDouble() * 1000 + _currentTime.microsecond;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        final offset = size / 2;

        updateAngles();
        updateDelta();

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 2*(size/7) + (size/2)),
                  Text(
                    "Δ: $_delta",
                    style: TextStyle(
                      color: ClockProperties.deltaColor,
                      fontSize: 12,
                    ),
                  )
                ]),
              ClockHand(
                angle: _chrono1Angle,
                width: 1,
                height: ClockProperties.chrono1HandLength,
                color: ClockProperties.chrono1HandColor,
                heightOffset: offset,
              ),
              ClockHand(
                angle: _chrono2Angle,
                width: 1,
                height: ClockProperties.chrono2HandLength,
                color: ClockProperties.chrono2HandColor,
                heightOffset: offset,
              ),
              ClockHand(
                angle: _hourAngle,
                width: 6,
                height: ClockProperties.hourHandLength,
                color: ClockProperties.hourHandColor,
                heightOffset: offset,
              ),
              ClockHand(
                angle: _minuteAngle,
                width: 4,
                height: ClockProperties.minuteHandLength,
                color: ClockProperties.minuteHandColor,
                heightOffset: offset,
              ),
              ClockHand(
                angle: _secondAngle,
                width: 2,
                height: ClockProperties.secondHandLength,
                color: ClockProperties.secondHandColor,
                heightOffset: offset,
              ),
            ],
          ),
        );
      },
    );
  }
}
