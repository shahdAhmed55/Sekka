import 'location_service.dart';
import 'sms_service.dart';
import '../dataBase/contacts_db.dart';
import '../dataBase/database_helper.dart';

class LiveTrackingService {
  static bool isTrackingActive = false;

  static Future<void> shareCurrentLocation({
    required int userId,
    required Function onComplete,
  }) async {
    try {
      print("Fetching and sharing location...");

      final location = await LocationService.getCurrentLocation();

      await DatabaseHelper.instance.saveTripLocation(
        userId: userId,
        latitude: location.latitude,
        longitude: location.longitude,
      );
      print("Location saved to SQLite");

      final contacts = await ContactsDb.getUserContacts(userId);

      if (contacts.isNotEmpty) {
        final message = """
 مشاركة الموقع الحالي (رحلتي في القطار)
موقعي الحالي هو:
https://maps.google.com/?q=${location.latitude},${location.longitude}
""";

        await SmsService.sendToContacts(
          contacts: contacts,
          message: message,
        );
        print("Location SMS triggered");
      }

      onComplete();
    } catch (e) {
      print("Error sharing location: $e");
      rethrow;
    }
  }
}
