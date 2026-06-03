import 'package:flutter/material.dart';
import 'package:shahd/screens/qr_scanner.dart';
import 'package:shahd/screens/ticket/emptyTicket.dart';
import 'package:shahd/screens/ticket/ticket.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/ticketProvider.dart';
import 'package:shahd/screens/notification_screen.dart';
import 'package:shahd/screens/sos/main.dart';
import 'package:shahd/screens/MyBook/emptyTrip.dart';
import 'package:shahd/screens/MyBook/book.dart';
import 'package:shahd/screens/profile.dart';
import 'package:shahd/providers/auth_provider.dart';
import 'package:shahd/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _bgCream = Color(0xFFFDFBF7);
  static const Color _textDark = Color(0xFF1C1C1C);
  static const Color _burgundy = Color(0xFF8B1E1E);
  static const Color _iconGrey = Color(0xFF757575);

  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    final hasTickets = Provider.of<TicketProvider>(context, listen: false).ticketsList.isNotEmpty;
    if (hasTickets) {
      _currentIndex = 2;
    }
  }

  static const List<Widget> _pages = [
    const ProfileScreen(),
    const MyBookMainScreen(),
    const TicketsMainScreen(),
    const _HomeBody(),
    const RailMateApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCream,
      appBar: AppBar(
        backgroundColor: _bgCream,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded, color: _burgundy, size: 24),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الخروج بنجاح', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Cairo')),
                backgroundColor: Color(0xFF8B1E1E),
                duration: Duration(seconds: 1),
              ),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: _textDark, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  errorBuilder: (context, error, stackTrace) {
                    return const CircleAvatar(
                      backgroundColor: _burgundy,
                      child: Text('سكة', style: TextStyle(color: Colors.white, fontSize: 12)),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB01E23),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            _currentIndex = 4;
          });
        },
        child: const Icon(Icons.shield_outlined, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex > 3 ? 3 : _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: _burgundy,
          unselectedItemColor: _iconGrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'),
          unselectedLabelStyle: const TextStyle(fontSize: 11, fontFamily: 'Cairo'),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
            BottomNavigationBarItem(icon: Icon(Icons.train_outlined), activeIcon: Icon(Icons.train), label: 'رحلاتي'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), activeIcon: Icon(Icons.confirmation_number), label: 'تذاكري'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    String displayUserName = (user != null && user.fullName.isNotEmpty) ? user.fullName : "المستخدم";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 30),
          Text(
            'أهلاً بك، يا $displayUserName',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C)),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          const Text(
            'رحلتك القادمة تبدأ من هنا',
            style: TextStyle(fontSize: 15, color: Color(0xFF757575)),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF090909),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                  const Spacer(),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'مسح ضوئي للتذكرة',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'التحقق من صحة تذكرتك فوراً',
                          style: TextStyle(color: Colors.white60, fontSize: 12, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'هذه الميزة غير متوفرة حاليا !',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 18)
                  ),
                  backgroundColor: const Color(0xFFB01E23),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF757575), size: 16),
                  const Spacer(),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'حجز تذكرة',
                          style: TextStyle(color: Color(0xFF1C1C1C), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ابحث عن رحلتك القادمة واحجز مقعدك',
                          style: TextStyle(color: Color(0xFF757575), fontSize: 12, fontFamily: 'Cairo'),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEFEF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF8B1E1E), size: 30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Color(0xFF1C1C1C), fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    );
  }
}