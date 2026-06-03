import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/ticketProvider.dart';
import 'package:shahd/screens/home.dart';
import 'package:shahd/services/notification_service.dart';
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false; // لمنع التكرار أثناء الحفظ والانتقال

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مسح الكود'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // الكاميرا
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (_isProcessing) return;

              final String? code = capture.barcodes.first.rawValue;
              if (code != null) {
                _isProcessing = true;

                try {

                  await Provider.of<TicketProvider>(context, listen: false)
                      .saveTicketFromQR(code);


                  await controller.stop();

                  if (!mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );

                  await NotificationService.instance.onQrScanSuccess();
                } catch (e) {
                  print("خطأ أثناء الحفظ: $e");
                  _isProcessing = false; // إعادة السماح بالمسح في حال الفشل
                }
              }
            },
          ),

          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}