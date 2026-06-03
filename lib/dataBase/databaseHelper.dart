import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shahd/models/ticketInformation.dart';
import 'package:shahd/models/user_model.dart';

class DatabaseHelper {
  static Database? database;

  static Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    }

    database = await openDatabase(
      join(await getDatabasesPath(), 'sekka_v3_clean_fixed.db'),
      version: 1,
      onCreate: (db, version) async {
        // 1️⃣ إنشاء جدول التذاكر
        await db.execute('''
          CREATE TABLE tickets(
            ticketId TEXT PRIMARY KEY,
            passengerName TEXT,
            fromStation TEXT,
            toStation TEXT,
            date TEXT,
            time TEXT,
            seat TEXT,
            status TEXT
          )
        ''');

        // 2️⃣ إنشاء جدول المستخدمين
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nationalId TEXT,               
            fullName TEXT,
            phoneNumber TEXT,
            password TEXT
          )
        ''');
      },
    );

    return database!;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 🎫 قـسـم الـتـذاكـر
  // ───────────────────────────────────────────────────────────────────────────

  static Future<void> insertTicket(TicketInformation ticket) async {
    final db = await getDatabase();
    await db.insert(
      'tickets',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<TicketInformation>> getTickets() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tickets');

    return List.generate(
      maps.length,
          (i) => TicketInformation.fromMap(maps[i]),
    );
  }

  static Future<void> clearAllTickets() async {
    final db = await getDatabase();
    await db.delete('tickets');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 👤 قـسـم الـمـسـتـخـدمـيـن
  // ───────────────────────────────────────────────────────────────────────────

  static Future<int> insertUser(UserModel user) async {
    final db = await getDatabase();

    final Map<String, dynamic> userMap = user.toJson();
    userMap.remove('id');

    return await db.insert(
      'users',
      userMap,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // 🟢 تعديل الدالة لتستقبل معرف المستخدم التلقائي (id) أو رقم الهاتف بدلاً من الرقم القومي الاختياري لتجنب الأخطاء
  static Future<UserModel?> getUserByPhone(String phoneNumber) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  static Future<UserModel?> getUserForLogin(String phoneNumber, String password) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'phoneNumber = ? AND password = ?',
      whereArgs: [phoneNumber, password],
    );
    if (maps.isNotEmpty) return UserModel.fromJson(maps.first);
    return null;
  }

  // 🟢 دالة جديدة ومهمة جداً: لتحديث بيانات المستخدم في قاعدة البيانات عند التعديل من البروفايل
  static Future<int> updateUser(UserModel user) async {
    final db = await getDatabase();
    return await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id], // نعتمد على الـ id الفريد لكل مستخدم تم إنشاؤه تلقائياً
    );
  }
}