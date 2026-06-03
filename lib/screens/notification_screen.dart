// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // ── Colours ──────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF5F1E6);
  static const _navy = Color(0xFF001B2A);
  static const _red = Color(0xFFC62828);

  @override
  void initState() {
    super.initState();
    NotificationService.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    NotificationService.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  // ── Format timestamp ──────────────────────────────────────────────────────
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }

  @override
  Widget build(BuildContext context) {
    final notifs = NotificationService.instance.notifications;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        title: const Text(
          'الإشعارات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (notifs.isNotEmpty)
            TextButton(
              onPressed: () {
                NotificationService.instance.markAllRead();
                setState(() {});
              },
              child: const Text(
                'قراءة الكل',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? _buildEmpty()
          : ListView.separated(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: notifs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) => _NotificationCard(
          notif: notifs[i],
          formatTime: _formatTime,
          onTap: () {
            NotificationService.instance.markRead(notifs[i].id);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 72, color: _red.withOpacity(.4)),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              color: _navy.withOpacity(.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Card ─────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final AppNotification notif;
  final String Function(DateTime) formatTime;
  final VoidCallback onTap;

  static const _navy = Color(0xFF001B2A);
  static const _red = Color(0xFFC62828);

  const _NotificationCard({
    required this.notif,
    required this.formatTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notif.isRead
                ? Colors.grey.shade200
                : _red.withOpacity(.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor:
            notif.isRead ? Colors.grey.shade200 : _red.withOpacity(.15),
            child: Icon(
              notif.isRead
                  ? Icons.notifications_none
                  : Icons.notifications_active,
              color: notif.isRead ? Colors.grey : _red,
              size: 22,
            ),
          ),
          title: Text(
            notif.title,
            style: TextStyle(
              fontWeight:
              notif.isRead ? FontWeight.normal : FontWeight.bold,
              color: _navy,
              fontSize: 14,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notif.body,
                style: TextStyle(
                  color: _navy.withOpacity(.7),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatTime(notif.timestamp),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          trailing: notif.isRead
              ? null
              : Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: _red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
