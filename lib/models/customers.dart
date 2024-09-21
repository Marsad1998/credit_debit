import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:credit_debit/db_connect.dart';

class Customers {
  static Future<int> createItem(String name, String? phone) async {
    final db = await SQLHelper.db();

    final data = {'name': name, 'phone': phone};
    final id = await db.insert('customers', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('customers', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('customers', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String name, String? phone) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'phone': phone,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('customers', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("customers", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
