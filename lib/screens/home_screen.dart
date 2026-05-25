import 'package:flutter/material.dart';
import 'package:sekka_app/screens/myTicketScreen.dart';

// --- الشاشة الرئيسية ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.logout, color: Color(0xFF8B1E1E)),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
          CircleAvatar(backgroundColor: Colors.white, child: Text('S')),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مرحباً بك في سكة',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'سافر بأمان وراحة إلى وجهتك المفضلة',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),

            // الزرار الذي ينقلك لصفحة التذاكر
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketsEmptyStateScreen()),
                );
              },
              icon: const Icon(Icons.confirmation_number_outlined, color: Colors.white),
              label: const Text(
                'عرض تذاكري',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB01E23),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
