import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/ticketProvider.dart';
import 'package:shahd/screens/ticket/emptyTicket.dart'; // تأكدي من مسار صفحة التذكرة الفاضية
import 'package:shahd/screens/ticket/detailedTicket.dart'; // تأكدي من مسار صفحة التذكرة المليانة

class TicketsMainScreen extends StatelessWidget {
  const TicketsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🟢 مراقبة البروفايدر بشكل مستمر لمعرفة هل تم إضافة تذكرة بعد السكان أم لا
    final ticketProvider = Provider.of<TicketProvider>(context);

    // 🔄 الفحص التلقائي: لو القائمة مليانة اعرض التفاصيل، لو فاضية اعرض الشاشة الفاضية
    if (ticketProvider.ticketsList.isNotEmpty) {
      return const TicketDetailsScreen();
    } else {
      return const TicketsEmptyStateScreen();
    }
  }
}