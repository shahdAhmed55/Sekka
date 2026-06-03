
import '../dataBase/contacts_db.dart';
import 'location_service.dart';
import 'sms_service.dart';

class SosService {
  static Future<void> triggerSOS({
    required int userId,
    required String userName,
  }) async {
    try {
      print("SOS STARTED");

      final List<Map<String, dynamic>> contacts = await ContactsDb.getUserContacts(userId);
      print("CONTACTS OK: ${contacts.length} contacts found");

      if (contacts.isEmpty) {
        throw 'لم تقم بإضافة أي جهات اتصال للطوارئ بعد!';
      }

      final location = await LocationService.getCurrentLocation();
      print("LOCATION OK");

      final message = """
🚨 نداء استغاثة طوارئ (SOS)

الاسم: $userName

موقعي الحالي على الخريطة:
https://maps.google.com/?q=${location.latitude},${location.longitude}

الوقت: ${DateTime.now().toLocal()}
""";

      await SmsService.sendToContacts(
        contacts: contacts,
        message: message,
      );

      print("SMS SENT TO ALL CONTACTS");
      print("SOS DONE");
    } catch (e) {
      print("");
      rethrow;
    }
  }
}