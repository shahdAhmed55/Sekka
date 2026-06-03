import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAlarm() async {
    try {
      // إيقاف أي صوت شغال الأول
      await _player.stop();

      // خلي الصوت عالي (1.0 يعني أعلى حاجة)
      await _player.setVolume(1.0);

      // 🛑 تعديل مهم: نخليها تغني مرة واحدة مش Loop عشان نقدر نتحكم في وقت الفصل
      await _player.setReleaseMode(ReleaseMode.release);

      // تشغيل الصوت
      await _player.play(
        AssetSource('assets/sounds/alarm.wav'),
      );

      // ⏳ مؤقت: بعد 3 ثواني (3000 مللي ثانية) يفصل التنبيه تلقائياً
      Future.delayed(const Duration(milliseconds: 3000), () {
        stopAlarm();
      });

    } catch (e) {
      print("Audio error: $e");
    }
  }

  static Future<void> stopAlarm() async {
    try {
      await _player.stop();
      await _player.release();
      print("🔊 Alarm stopped after 3 seconds");
    } catch (e) {
      print("Stop audio error: $e");
    }
  }
}