import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  static Future<void> startAlertVibration() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();

      if (hasVibrator != true) {
        HapticFeedback.heavyImpact();
        return;
      }

      await Vibration.vibrate(
        pattern: [0, 800, 300, 800, 300, 800, 300, 1200],
      );

      Future.delayed(const Duration(milliseconds: 2000), () async {
        if (await Vibration.hasVibrator() == true) {
          Vibration.vibrate(duration: 1500);
        }
      });
    } catch (e) {
      HapticFeedback.heavyImpact();
      HapticFeedback.vibrate();
    }
  }

  static Future<void> stop() async {
    try {
      Vibration.cancel();
    } catch (e) {}
  }
}
