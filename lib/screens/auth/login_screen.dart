import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shahd/providers/auth_provider.dart';
import 'package:shahd/screens/auth/register_screen.dart'; // للتوجيه لإنشاء الحساب
import 'package:shahd/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar("رجاءً أدخل رقم الهاتف وكلمة السر", Colors.orange);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isSuccess = await authProvider.login(phone, password);

    if (isSuccess) {
      if (!mounted) return;
      _showSnackBar("مرحباً بك مجدداً في سكة! 🎉", Colors.green);


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      if (!mounted) return;
      _showSnackBar("رقم الهاتف أو كلمة السر غير صحيحة", Colors.red);
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
        backgroundColor: const Color(0xFFFBF9F4), // نفس لون الخلفية الهادئ للتطبيق
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الشعار ونصوص الترحيب المطابقة تماماً للصورة
                Image.asset(
                  'assets/images/logo.jpg',
                  height: 120,
                  errorBuilder: (_, __, ___) => const Icon(Icons.train, size: 100, color: Color(0xFF0B223B)),
                ),
                const SizedBox(height: 24),

                // حاوية بيضاء تحتوي على حقول الإدخال لتطابق المظهر الجمالي المرفق
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0B223B), fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "مرحباً بك مجدداً في رحلتك القادمة",
                        style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 24),

                      // حقل رقم الهاتف
                      _buildInputField(
                        "رقم الهاتف",
                        "01XXXXXXXX",
                        Icons.phone_android_outlined,
                        _phoneController,
                        keyboardType: TextInputType.phone,
                      ),

                      // حقل كلمة السر المرتبط بالبروفايدر للرؤية والإخفاء
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

                      // زر نسيت كلمة السر
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // إضافة أكواد استعادة كلمة السر لاحقاً إذا رغبتِ
                          },
                          child: const Text(
                            "نسيت كلمة السر؟",
                            style: TextStyle(color: Colors.red, fontSize: 12, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // زر تسجيل الدخول المتناسق باللون الكحلي الداكن والأيقونة
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B223B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _loginUser,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white), // اتجاه السهم متناسق مع الاتجاه العربي
                              SizedBox(width: 12),
                              Text(
                                "تسجيل الدخول",
                                style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // زر التحويل لصفحة إنشاء حساب جديد
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                      children: [
                        TextSpan(text: "ليس لديك حساب؟ ", style: TextStyle(color: Colors.black54)),
                        TextSpan(text: "إنشاء حساب جديد", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13, color: Colors.black87),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            fillColor: const Color(0xFFF8FAFC), // خلفية خفيفة جداً داخل الحقل للحصول على عمق التصميم
            filled: true,
            prefixIcon: Icon(icon, color: Colors.black45, size: 22),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black45),
              onPressed: suffixAction,
            )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0B223B), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}