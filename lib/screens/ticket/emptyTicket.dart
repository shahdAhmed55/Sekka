import 'package:flutter/material.dart';

class TicketsEmptyStateScreen extends StatelessWidget {
  const TicketsEmptyStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 🟢 قمنا بإزالة الـ Scaffold والـ SafeArea لتعمل داخل الـ IndexedStack الخاص بالهوم
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.05),
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.confirmation_number_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    Transform.rotate(
                      angle: -0.7,
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
              fontFamily: 'Cairo', // لإعطائها مظهراً متناسقاً
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'لم يتم حجز أي تذكرة أو مسحها ضوئياً بعد. ابدأ رحلتك القادمة الآن.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.5,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}