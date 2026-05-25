import 'package:flutter/material.dart';

class TicketsEmptyStateScreen extends StatelessWidget {
  const TicketsEmptyStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE), // لون الخلفية البيج الفاتح


      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.logout, color: Color(0xFF8B1E1E)), // أيقونة الخروج
      //     onPressed: () {},
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.notifications_none, color: Colors.black87), // التنبيهات
      //       onPressed: () {},
      //     ),
      //     const Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 16.0),
      //       child: CircleAvatar(
      //         radius: 18,
      //         backgroundColor: Colors.white,
      //
      //         backgroundImage: AssetImage('images/logo.jpg'),
      //       ),
      //     ),
      //   ],
      // ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.05),

                  ),
                  child: Center(
                    // أيقونة التذكرة وعليها خط مائل أحمر
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        Transform.rotate(
                          angle: -0.7, // زاوية الخط المائل الأحمر
                          child: Container(
                            width: 100,
                            height: 6,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),


              const Text(
                'لا توجد تذاكر حالياً',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),


              Text(
                'لم يتم حجز أي تذكرة أو مسحها ضوئياً بعد. ابدأ رحلتك القادمة الآن.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: const Text(
                  'مسح تذكرة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),

              ),
              const SizedBox(height: 12),


              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'حجز تذكرة جديدة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),


      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0xFFB01E23),
      //   shape: const CircleBorder(),
      //   child: const Icon(Icons.add_moderator, color: Colors.white),
      // ),


    // bottomNavigationBar: BottomNavigationBar(
    // type: BottomNavigationBarType.fixed,
    // backgroundColor: Colors.white,
    // selectedItemColor: const Color(0xFFB01E23),
    // unselectedItemColor: Colors.grey,
    // currentIndex: 1,
    // selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
    // unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
    // items: const [
    // BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
    // BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'تذاكري'),
    // BottomNavigationBarItem(icon: Icon(Icons.train_outlined), label: 'رحلاتي'),
    // BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
    // ],
    // ),
    );
    }
    }



