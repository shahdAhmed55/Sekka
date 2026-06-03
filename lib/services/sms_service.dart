import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class SmsService {
  static Future<void> sendToContacts({
    required List<Map<String, dynamic>> contacts,
    required String message,
  }) async {
    if (contacts.isEmpty) {
      print("⚠️ لا توجد جهات اتصال طوارئ مخزنة لإرسال الرسالة إليها.");
      return;
    }

    List<String> validPhones = [];
    for (var contact in contacts) {
      final phoneRaw = contact['contact_phone'];
      if (phoneRaw != null && phoneRaw.toString().trim().isNotEmpty) {
        validPhones.add(phoneRaw.toString().trim());
      }
    }

    if (validPhones.isEmpty) {
      print("⚠️ لم يتم العثور على أرقام هواتف صالحة.");
      return;
    }

    // 🟢 2. دمج الأرقام بفواصل بناءً على نوع نظام التشغيل (أندرويد يستخدم فاصلة، iOS يستخدم فاصلة منقوطة)
    String separator = Platform.isAndroid ? ',' : ';';
    String allPhones = validPhones.join(separator);

    print("📱 جاري توجيه الرسالة إلى الجهات المضافة معاً: $allPhones");

    // 3. إعداد الـ Uri الجماعي
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: allPhones, // 👈 هنا نمرر كل الأرقام مدمجة معاً
      queryParameters: <String, String>{
        'body': message,
      },
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(
          smsUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        print("✅ تم فتح تطبيق الرسائل بنجاح ومدرج به جميع الأرقام.");
      } else {
        print("تعذر فتح تطبيق الرسائل للمجموعة.");
      }
    } catch (e) {
      print("");
    }
  }
}