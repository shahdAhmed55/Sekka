import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shahd/dataBase/databaseHelper.dart';
import 'package:shahd/models/ticketInformation.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketInformation> _ticketsList = [];
  bool _isLoading = false;

  // 🔴 1. المتغير الجديد والـ Getter الخاص بحالة المسح
  bool _scanned = false;
  bool get scanned => _scanned;

  List<TicketInformation> get ticketsList => _ticketsList;
  bool get isLoading => _isLoading;

  // دالة لجلب كل التذاكر من الداتا بيز (وتحديث حالة الـ scanned بناءً على وجود داتا)
  Future<void> fetchAllTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _ticketsList = await DatabaseHelper.getTickets();

      // لو قاعدة البيانات رجعت تذاكر ممسوحة قبل كدة، نخلي scanned بـ true تلقائياً
      if (_ticketsList.isNotEmpty) {
        _scanned = true;
      }
    } catch (e) {
      print("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// 🔴 تم حذف الباراميتر الثاني وجعل القيمة true تلقائياً داخل الدالة
  Future<void> saveTicketFromQR(String rawJson) async {
    try {
      // تحديث حالة المتغير مباشرة داخل الدالة دون باراميتر خارجي
      _scanned = true;

      Map<String, dynamic> decodedJson = jsonDecode(rawJson);
      TicketInformation newTicket = TicketInformation(
        ticketId: decodedJson['ticketId']?.toString() ?? 'unknown',
        passengerName: decodedJson['passengerName']?.toString() ?? 'unknown',
        from: (decodedJson['fromStation'] ?? decodedJson['from'])?.toString() ?? '',
        to: (decodedJson['toStation'] ?? decodedJson['to'])?.toString() ?? '',
        date: decodedJson['date']?.toString() ?? '',
        time: decodedJson['time']?.toString() ?? '',
        seat: decodedJson['seat']?.toString() ?? '',
        status: decodedJson['status']?.toString() ?? 'Pending',
      );

      // حفظ في قاعدة البيانات المحلية
      await DatabaseHelper.insertTicket(newTicket);

      // إضافة التذكرة الجديدة في أول القائمة المعروضة
      _ticketsList.insert(0, newTicket);

      // تنبيه الشاشات بالتحديث الجديد
      notifyListeners();

    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  // دالة التذكرة التلقائية المحدثة أيضاً لتتوافق مع التغيير الجديد
  Future<void> saveTimeoutMockTicket() async {
    try {
      String mockTicketJson = '''
      {
        "ticketId": "SEKKA-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
        "passengerName": "رايدر سكة (تلقائي)",
        "fromStation": "القاهرة",
        "toStation": "أسوان",
        "date": "2026-05-30",
        "time": "08:00 م",
        "seat": "A-12",
        "status": "Confirmed"
      }
      ''';

      // استدعاء الدالة المحدثة بدون الباراميتر المحذوف
      await saveTicketFromQR(mockTicketJson);
    } catch (e) {
      print("Error saving timeout mock ticket: $e");
      rethrow;
    }
  }
  // 💡 دالة إضافية مفيدة: لو حابة تعملي تسجيل خروج أو مسح للحالة وترجعي للشاشة الفاضية
  void resetScannedStatus() {
    _scanned = false;
    notifyListeners();
  }
}