import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../services/sos_service.dart';
import '../../services/audio_service.dart';
import '../../services/vibration_service.dart';
import '../../services/live_tracking_service.dart';
import 'package:shahd/services/notification_service.dart';
import 'package:shahd/providers/auth_provider.dart';
import '../../widgets/emergency_contacts_section.dart';
import '../../widgets/tip_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _triggerEmergencyAction(
    BuildContext context,
    int userId,
    String userName,
  ) async {
    try {
      await SosService.triggerSOS(userId: userId, userName: userName);

      await VibrationService.startAlertVibration();
      await AudioService.playAlarm();
      await NotificationService.instance.onEmergencyTriggered();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إرسال الاستغاثة والموقع بنجاح لجهات الاتصال المحددة',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$e',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleShareLocation(BuildContext context, int userId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'جاري تحديد موقعك الحالي...',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      await LiveTrackingService.shareCurrentLocation(
        userId: userId,
        onComplete: () async {
          await NotificationService.instance.onShareLocationSuccess();

          if (context.mounted) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم تحديد الموقع بنجاح وتحديث بيانات رحلتك',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                ),
                backgroundColor: AppColors.successGreen,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تعذر تحديد الموقع: $e',
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final int userId = user?.id ?? 1;
    final String userName = (user != null && user.fullName.isNotEmpty)
        ? user.fullName
        : "مستخدم سكة";

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'مشاركة الموقع المباشر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ابقِ عائلتك على اطلاع دائم بمكانك خلال رحلتك في السكة الحديدية.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _handleShareLocation(context, userId),
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text(
                      'تفعيل المشاركة الآن',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            EmergencyContactsSection(currentUserId: userId),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.topRight,
              child: Text(
                'نصائح لرحلة آمنة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            const TipCard(
              title: 'حافظ على أمتعتك',
              subtitle: 'ابقِ حقائبك دائماً في مرمى بصرك أو في الرفوف المخصصة.',
              icon: Icons.business_center_outlined,
            ),
            const TipCard(
              title: 'مخارج الطوارئ',
              subtitle: 'تعرف على أقرب مخرج طوارئ لك عند صعودك إلى العربة.',
              icon: Icons.warning_amber_rounded,
            ),
            const TipCard(
              title: 'طلب المساعدة',
              subtitle:
                  'لا تتردد في التواصل مع مشرف القطار عند ملاحظة أي أمر مريب.',
              icon: Icons.support_agent,
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => _triggerEmergencyAction(context, userId, userName),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.darkRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning_sharp, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'إرسال البيانات والموقع للجهات المعنية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'سيتم إرسال إحداثياتك الحالية فوراً للجهات المحددة',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
