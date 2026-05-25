import 'package:flutter/material.dart';

class TicketsEmptyStateScreen extends StatelessWidget {
  final String? scannedTicketData;
  const TicketsEmptyStateScreen({Key? key, this.scannedTicketData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasTicket = scannedTicketData != null && scannedTicketData!.isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: hasTicket
              ? _buildTicketDetailsWidget(scannedTicketData!)
              : _buildEmptyStateWidget(context),

        ),
      ),
    );
    }
    }


//String ticketData
Widget _buildTicketDetailsWidget(String ticketData) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text('قنا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('أسوان', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text(
                '2026/5/7',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text('قطار رقم 980', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('VIP سريعة ومريحة', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                  const Text(
                          'مؤكد',
                          style: TextStyle(color: Color(0xFFB01E23), fontSize: 12, fontWeight: FontWeight.bold),
                        ),


                    ],
                  ),
                  const SizedBox(height: 24),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('قنا', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('17:40', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                        children: const [
                          Text('أسوان', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('22:25', style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                        children: const [
                          Text('المدة: 4h 45m', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          SizedBox(width: 6),
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 50),


                  Row(
                    children: [
                      // الدرجة الثانية
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: const [
                              Text('الدرجة الثانية (17)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              SizedBox(height: 4),
                              Text('EGP 150,00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // الدرجة الأولى
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF6F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFB01E23).withOpacity(0.2)),
                          ),
                          child: Column(
                            children: const [
                              Text('الدرجة الأولى (3)', style: TextStyle(fontSize: 12, color: Color(0xFFB01E23))),
                              SizedBox(height: 4),
                              Text('EGP 210,00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFB01E23))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),


                  ElevatedButton(
                    onPressed: () {},
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
  );
}

Widget _buildEmptyStateWidget(BuildContext context) {
  return Column(
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
                Icon(
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
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'هذه الميزة غير متوفرة حاليا !',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                  )
              ),
              backgroundColor: const Color(0xFFB01E23),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,

            ),
          );
        },
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
  );
}