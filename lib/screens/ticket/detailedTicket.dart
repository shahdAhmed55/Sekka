import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/ticketProvider.dart';
import 'package:shahd/models/ticketInformation.dart';
import 'package:shahd/screens/MyBook/TripDetails.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String? scannedTicketData;

  const TicketDetailsScreen({Key? key, this.scannedTicketData}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    // 1. قراءة البروفايدر
    final ticketProvider = Provider.of<TicketProvider>(context);

    // 3. 🔴 التعديل الصحيح: قراءة أول تذكرة (الأحدث) من الـ List الموجودة في البروفايدر
    final TicketInformation? ticket = ticketProvider.ticketsList.isNotEmpty
        ? ticketProvider.ticketsList.first
        : null;

    // في حال كان جاري جلب البيانات والتيكت لسه مجهزنش في الـ List
    if (ticket == null) {
      return const Scaffold(
        backgroundColor: const Color(0xFFF9F6EE),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFB01E23))),
      );
    }

    // قراءة البيانات الاحترافية كـ Properties من الـ Object مباشرة 🚀
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(ticket.from, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(ticket.to, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        ticket.date,
                        style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.train, color: Color(0xFFB01E23), size: 28),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('قطار رقم ${ticket.ticketId}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const Text('VIP سريعة ومريحة', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                ticket.status, // جعل الحالة ديناميكية قادمة من الموديل (Pending / Confirmed...)
                                style: const TextStyle(color: Color(0xFFB01E23), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ticket.from, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(ticket.time, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(height: 2, color: const Color(0xFFB01E23)),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(color: Color(0xFFB01E23), shape: BoxShape.circle),
                                      child: const Icon(Icons.train_rounded, color: Colors.white, size: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(ticket.to, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text('22:25', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('مقعد رقم: ${ticket.seat}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.airline_seat_recline_normal, size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const TripdetailsScreen()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D1E2D),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 54),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('الذهاب لمتابعة الرحلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.keyboard_double_arrow_left, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF6F6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFB01E23).withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 18),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'تم مسح التذكرة بنجاح',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}