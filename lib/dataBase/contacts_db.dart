import 'database_helper.dart';

class ContactsDb {
  static final db = DatabaseHelper.instance;

  // Add Contact
  static Future<int> addContact(Map<String, dynamic> contact) async {
    final database = await db.database;
    return await database.insert('emergency_contacts', contact);
  }

  // Get Contacts for User
  static Future<List<Map<String, dynamic>>> getUserContacts(int userId) async {
    final database = await db.database;

    return await database.query(
      'emergency_contacts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Delete Contact
  static Future<int> deleteContact(int id) async {
    final database = await db.database;

    return await database.delete(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
