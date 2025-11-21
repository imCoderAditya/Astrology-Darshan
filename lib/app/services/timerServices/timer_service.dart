import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

class TimerService {
  Timer? _timer;

  void startTimer({
    required int endTimeInMinutes,
    required Function(Duration elapsed) onTick,
    required VoidCallback onComplete,
  }) {
    _timer?.cancel();

    int elapsedSeconds = 0;
    final totalSeconds = endTimeInMinutes * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      log("Total Second: $totalSeconds");
      if (elapsedSeconds > totalSeconds) {
        timer.cancel();
        onComplete();

      } else {      
        onTick(Duration(seconds: elapsedSeconds));
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
