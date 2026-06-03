// lib/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  final List<AppNotification> notifications = [];

  // ── Listeners ──────────────────────────────────────────────────────────────
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback cb) => _listeners.add(cb);

  void removeListener(VoidCallback cb) => _listeners.remove(cb);

  void _notify() {
    for (final cb in _listeners) {
      cb();
    }
  }

  int get unreadCount =>
      notifications
          .where((n) => !n.isRead)
          .length;

  // ── Init ───────────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (kIsWeb) return;
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings,
        onDidReceiveNotificationResponse: _onTap);
  }

  void _onTap(NotificationResponse response) {
    final match =
    notifications.where((n) => n.id == response.payload).toList();
    if (match.isNotEmpty) {
      match.first.isRead = true;
      _notify();
    }
  }

  // ── Permission ─────────────────────────────────────────────────────────────
  Future<bool> requestPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // ── Send ───────────────────────────────────────────────────────────────────
  Future<void> send({
    required String title,
    required String body,
    String? payload,
  }) async {
    final id = DateTime
        .now()
        .millisecondsSinceEpoch;
    final notif = AppNotification(
      id: id.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );

    notifications.insert(0, notif);
    _notify();

    if (!kIsWeb) {
      const androidDetails = AndroidNotificationDetails(
        'sekka_channel',
        'Sekka Notifications',
        channelDescription: 'General Sekka app notifications',
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      const details =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
      await _plugin.show(id, title, body, details,
          payload: payload ?? notif.id);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    _notify();
  }

  void markRead(String id) {
    final match = notifications.where((n) => n.id == id).toList();
    if (match.isNotEmpty) {
      match.first.isRead = true;
      _notify();
    }
  }

  // ── أحداث جاهزة ───────────────────────────────────────────────────────────
  Future<void> onRegister() =>
      send(
        title: '🎉 مرحباً بك في سكة!',
        body: 'تم إنشاء حسابك بنجاح.',
      );


  Future<void> onUpdateProfile() =>
      send(
        title: '👤 تم تحديث بياناتك',
        body: 'تم حفظ التعديلات بنجاح.',
      );


  Future<void> onQrScanSuccess() =>
      send(
        title: '️ تم إضافة تذكرتك بنجاح',
        body: 'تم قراءة الـ QR كود وحفظ بيانات رحلتك الجديدة في السكة الحديدية.',
      );


  Future<void> onShareLocationSuccess() => send(
    title: ' تم تحديد الموقع بنجاح',
    body: 'تم تحديث موقعك الحالي في القطار ومشاركته لطمأنة عائلتك.',
  );

  Future<void> onEmergencyTriggered() => send(
    title: 'نداء استغاثة (SOS)',
    body: 'تم إرسال إحداثياتك الحالية فوراً وبيانات الرحلة لجميع جهات الاتصال.',
  );
}