import 'package:flutter/material.dart';

class EmptyTripPage extends StatelessWidget {
  const EmptyTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // إجبار اللون المصمت الكريمي المتناسق مع الهوية لمنع أي شفافية
      backgroundColor: const Color(0xFFFDFBF7),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الدوائر المتداخلة وأيقونة المنع
                Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAE8E1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDEDCD5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.train_outlined,
                                size: 48, color: Color(0xFFB0AEA7)),
                            Positioned(
                              child: Icon(Icons.block,
                                  size: 60, color: Color(0xFFE24B4A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'لا توجد رحلات مجدولة حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'لم تخطط لأي رحلة قادمة بعد. استكشف الوجهات المتاحة وابدأ مغامرتك الجديدة.',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: Color(0xFF888780),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}