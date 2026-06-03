import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/auth_provider.dart';
import '../../services/notification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedBottomIndex = -1;
  bool isNotificationActive = false;

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFFF5F1E6);
    const navyColor = Color(0xFF001B2A);

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // جلب البيانات الحقيقية أو وضع قيم افتراضية مؤقتة إذا لم يكتمل التحميل
    String userName = (user != null && user.fullName.isNotEmpty) ? user.fullName : "بدون اسم";
    String phoneNumber = user?.phoneNumber ?? "";
    String nationalId = user?.nationalId ?? "";
    String password = user?.password ?? "";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyColor),
                ),
                const Text('مشترك', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF8F5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      _buildStaticProfileItem(Icons.person_outline, 'الاسم بالكامل', userName, 'برجاء ادخال الاسم بالكامل'),
                      const Divider(color: Color(0xFFEEE3CF), thickness: 1, height: 14),
                      _buildStaticProfileItem(Icons.phone_android, 'رقم الهاتف', phoneNumber, '01XXXXXXXXX'),
                      const Divider(color: Color(0xFFEEE3CF), thickness: 1, height: 14),

                      _buildStaticProfileItem(Icons.badge_outlined, 'الرقم القومي', nationalId, 'لم يتم تسجيل رقم قومي (اختياري)'),
                      const Divider(color: Color(0xFFEEE3CF), thickness: 1, height: 14),
                      _buildStaticProfileItem(Icons.lock_outline, 'كلمة السر', password, '********', isPassword: true),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF262E3B),
                    minimumSize: const Size(double.infinity, 42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    String passedName = userName == "بدون اسم" ? "" : userName;

                    final Map<String, String> dataToSend = {
                      'currentName': passedName,
                      'currentPhone': phoneNumber,
                      'currentNationalId': nationalId,
                      'currentPassword': password,
                    };

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(currentData: dataToSend),
                      ),
                    );

                    if (result != null && result is Map<String, String>) {

                      if (authProvider.currentUser != null) {
                        authProvider.currentUser = authProvider.currentUser!.copyWith(
                          fullName: result['name'] ?? '',
                          phoneNumber: result['phone'] ?? '',
                          nationalId: result['nationalId'] ?? '',
                          password: result['password'] ?? '',
                        );


                        authProvider.notifyListeners();
                      }


                      await NotificationService.instance.onUpdateProfile();
                    }
                  },
                  icon: const Icon(Icons.edit_note, color: Colors.white, size: 20),
                  label: const Text('تعديل البيانات', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticProfileItem(IconData icon, String label, String value, String placeholder, {bool isPassword = false}) {
    String displayText;
    Color textColor;

    if (value.trim().isEmpty) {
      displayText = placeholder;
      textColor = Colors.grey.shade400;
    } else {
      displayText = isPassword ? '********' : value;
      textColor = const Color(0xFF001B2A);
    }

    return Row(
      children: [
        Icon(icon, color: const Color(0xFF001B2A).withOpacity(0.6), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(height: 1),
              Text(
                displayText,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> currentData;

  const EditProfileScreen({
    super.key,
    required this.currentData,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _editNameController;
  late TextEditingController _editPhoneController;
  late TextEditingController _editNationalIdController;
  late TextEditingController _editPasswordController;

  @override
  void initState() {
    super.initState();

    String initialName = widget.currentData['currentName'] ?? '';
    String initialPhone = widget.currentData['currentPhone'] ?? '';
    String initialNationalId = widget.currentData['currentNationalId'] ?? '';
    String initialPassword = widget.currentData['currentPassword'] ?? '';

    _editNameController = TextEditingController(text: initialName);
    _editPhoneController = TextEditingController(text: initialPhone);
    _editNationalIdController = TextEditingController(text: initialNationalId);
    _editPasswordController = TextEditingController(text: initialPassword);
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editPhoneController.dispose();
    _editNationalIdController.dispose();
    _editPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFFF5F1E6);
    const navyColor = Color(0xFF001B2A);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          title: const Text('تعديل البيانات', style: TextStyle(color: navyColor, fontSize: 16, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: navyColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8F5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _editNameController,
                          decoration: const InputDecoration(
                            labelText: 'الاسم بالكامل',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(Icons.person_outline, size: 20),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _editPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(Icons.phone_android, size: 20),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _editNationalIdController,
                          decoration: const InputDecoration(
                            labelText: 'الرقم القومي',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(Icons.badge_outlined, size: 20),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _editPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'كلمة السر',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(Icons.lock_outline, size: 20),
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      minimumSize: const Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final Map<String, String> updatedData = {
                        'name': _editNameController.text,
                        'phone': _editPhoneController.text,
                        'nationalId': _editNationalIdController.text,
                        'password': _editPasswordController.text,
                      };

                      Navigator.pop(context, updatedData);
                    },
                    icon: const Icon(Icons.save, color: Colors.white, size: 18),
                    label: const Text('حفظ التعديلات والعودة', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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