import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/audio_service.dart';
import '../../services/vibration_service.dart';
import 'home_screen.dart';

class EmergencyTypesScreen extends StatelessWidget {
  const EmergencyTypesScreen({super.key});

  void _handleSosActivation(BuildContext context) async {
    await VibrationService.startAlertVibration();
    await AudioService.playAlarm();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () => _handleSosActivation(context),
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.darkRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // تم التحديث هنا لتجنب التحذير
                    color: AppColors.darkRed.withValues(alpha: 0.35),
                    spreadRadius: 8,
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'طوارئ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
