import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/auth_provider.dart';
import 'package:shahd/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _acceptTerms = false;

  // الكنترولرز الخاصة بالتحكم في الحقول
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    // نأخذ الرقم القومي كنص String صافي تماماً، وإذا كان فارغاً نمرره كـ null
    final nationalId = _nationalIdController.text.trim().isEmpty
        ? null
        : _nationalIdController.text.trim();

    // التحقق من الحقول المطلوبة فقط (الاسم، الهاتف، كلمة السر)
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      _showSnackBar("رجاءً قم بملء الحقول الإلزامية أولاً", Colors.orange);
      return;
    }

    if (!_acceptTerms) {
      _showSnackBar("يجب الموافقة على الشروط والأحكام لإتمام التسجيل", Colors.orange);
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // إرسال البيانات إلى البروفايدر
      bool isSuccess = await authProvider.register(
        fullName: name,
        phoneNumber: phone,
        nationalId: nationalId, // يمرر هنا كـ String? بأمان تام
        password: password,
      );

      if (isSuccess) {
        if (!mounted) return;
        _showSnackBar("تم إنشاء الحساب بنجاح!", Colors.green);

        // الانتقال لصفحة تسجيل الدخول ومسح الشاشات السابقة
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      } else {
        _showSnackBar("فشل التسجيل، يرجى التحقق من البيانات", Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ أثناء حفظ البيانات: $e", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo'), textAlign: TextAlign.center),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF9F4),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', height: 120, errorBuilder: (_, __, ___) => const Icon(Icons.train, size: 100, color: Color(0xFF0B223B))),
                const SizedBox(height: 8),
                const Text("إنشاء حساب جديد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Color(0xFF0B223B))),
                const SizedBox(height: 4),
                const Text("انضم إلى مجتمع المسافرين عبر سكك حديد مصر", style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Cairo')),
                const SizedBox(height: 24),

                _buildInputField("الاسم الكامل", "أدخل اسمك كما في البطاقة", Icons.person_outline, _nameController),
                _buildInputField("رقم الهاتف", "01x xxxx xxxx", Icons.phone_android_outlined, _phoneController, keyboardType: TextInputType.phone),
                _buildInputField("الرقم القومي (اختياري)", "١٤ رقم", Icons.badge_outlined, _nationalIdController, keyboardType: TextInputType.number),

                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return _buildInputField(
                      "كلمة السر",
                      "••••••••",
                      Icons.lock_outline,
                      _passwordController,
                      isPassword: true,
                      obscureText: auth.obscurePass,
                      suffixAction: () => auth.toggleObscure(),
                    );
                  },
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      activeColor: Colors.red,
                      onChanged: (v) => setState(() => _acceptTerms = v!),
                    ),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.black87),
                          children: [
                            TextSpan(text: "بإنشاء حساب، أنت توافق على "),
                            TextSpan(text: "الشروط والأحكام", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            TextSpan(text: " الخاصة بسكة."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B223B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _registerUser,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.white),
                        SizedBox(width: 12),
                        Text("إنشاء حساب", style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text.rich(
                    TextSpan(
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      children: [
                        TextSpan(text: "تمتلك حساب؟ ", style: TextStyle(color: Colors.black54)),
                        TextSpan(text: "سجل الدخول", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller, {
        bool isPassword = false,
        bool obscureText = false,
        VoidCallback? suffixAction,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 6, right: 4),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13, color: Colors.black87)),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.black45, size: 22),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black45),
              onPressed: suffixAction,
            )
                : null,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0B223B), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}