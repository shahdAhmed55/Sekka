import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../dataBase/databaseHelper.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? currentUser;
  bool isLoggedIn = false;
  bool obscurePass = true;

  void toggleObscure() {
    obscurePass = !obscurePass;
    notifyListeners();
  }

  // 1️⃣ دالة إنشاء حساب جديد (موجودة وجاهزة مع الـ Null Safety)
  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    String? nationalId,
    required String password,
  }) async {
    try {
      final user = UserModel(
        fullName: fullName,
        phoneNumber: phoneNumber,
        nationalId: nationalId,
        password: password,
      );

      int resultId = await DatabaseHelper.insertUser(user);

      if (resultId > 0) {
        currentUser = user;
        isLoggedIn = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error at AuthProvider register: $e");
      rethrow;
    }
  }

  // 2️⃣ 🟢 الدالة الجديدة: تسجيل الدخول والتحقق من الهاتف وباسوورد المستخدم
  Future<bool> login(String phoneNumber, String password) async {
    try {
      // استدعاء قاعدة البيانات للبحث عن تطابق الهاتف والسر
      final user = await DatabaseHelper.getUserForLogin(phoneNumber, password);

      if (user != null) {
        currentUser = user;
        isLoggedIn = true;
        notifyListeners(); // تحديث الواجهات فوراً ببيانات المستخدم الجديد
        return true;
      }
      return false; // لم يتم العثور على الحساب أو البيانات خاطئة
    } catch (e) {
      debugPrint("Error at AuthProvider login: $e");
      return false;
    }
  }

  // دالة إضافية لتسجيل الخروج إذا احتجتِ إليها لاحقاً
  void logout() {
    currentUser = null;
    isLoggedIn = false;
    notifyListeners();
  }
}