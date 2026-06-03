import '../../../dataBase/databaseHelper.dart';

class UserModel {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final String? nationalId;
  final String password;

  UserModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    this.nationalId,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      nationalId: json['nationalId'] as String?,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'password': password,
    };
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? nationalId,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalId: nationalId ?? this.nationalId,
      password: password ?? this.password,
    );
  }

  static Future<int> insertUser(UserModel user) async {
    final db = await DatabaseHelper.getDatabase();
    final Map<String, dynamic> userMap = user.toJson();
    userMap.remove('id'); // 🟢 يضمن عدم إرسال أي id مانيوال ضخم يسبب خطأ الـ 32-bit
    return await db.insert(
      'users',
      userMap,
    );
  }

  static Future<UserModel?> getUserById(int id) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  static Future<UserModel?> login(String phoneNumber, String password) async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'phoneNumber = ? AND password = ?',
      whereArgs: [phoneNumber, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() async {
    final db = await DatabaseHelper.getDatabase();
    final result = await db.query('users');
    return result.map((json) => UserModel.fromJson(json)).toList();
  }
}